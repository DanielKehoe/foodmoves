module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module PayflowCommonAPI
      def self.included(base)
        base.default_currency = 'USD'
          
        # The certification id requirement has been removed by Payflow
        # This is no longer being sent in the requests to the gateway
        base.class_inheritable_accessor :certification_id

        base.class_inheritable_accessor :partner
        
        # Set the default partner to PayPal
        base.partner = 'PayPal'
        
        base.supported_countries = ['US', 'CA', 'SG', 'AU']
        
        base.class_inheritable_accessor :timeout
        base.timeout = 60
        
        # Enable safe retry of failed connections
        # Payflow is safe to retry because retried transactions use the same
        # X-VPS-Request-ID header. If a transaction is detected as a duplicate
        # only the original transaction data will be used by Payflow, and the
        # subsequent Responses will have a :duplicate parameter set in the params
        # hash.
        base.retry_safe = true
      end
      
      XMLNS = 'http://www.paypal.com/XMLPay'
      TEST_URL = 'https://pilot-payflowpro.verisign.com'
      LIVE_URL = 'https://payflowpro.verisign.com'
      
      CARD_MAPPING = {
        :visa => 'Visa',
        :master => 'MasterCard',
        :discover => 'Discover',
        :american_express => 'Amex',
        :jcb => 'JCB',
        :diners_club => 'DinersClub',
        :switch => 'Switch',
        :solo => 'Solo'
      }
      
      TRANSACTIONS = { 
        :purchase       => "Sale",
        :authorization  => "Authorization",
        :capture        => "Capture",
        :void           => "Void",
        :credit         => "Credit" 
      }
          
      def initialize(options = {})
        requires!(options, :login, :password)
        @options = {
          :certification_id => self.class.certification_id,
          :partner => self.class.partner
        }.update(options)
        
        super
      end  
      
      def test?
        @options[:test] || Base.gateway_mode == :test
      end
      
      def capture(money, authorization, options = {})
        request = build_reference_request(:capture, money, authorization, options)
        commit(request)
      end
      
      def void(authorization, options = {})
        request = build_reference_request(:void, nil, authorization, options)
        commit(request)
      end
  
      private      
      def build_request(body, request_type = nil)
        xml = Builder::XmlMarkup.new :indent => 2
        xml.instruct!
        xml.tag! 'XMLPayRequest', 'Timeout' => 30, 'version' => "2.1", "xmlns" => XMLNS do
          xml.tag! 'RequestData' do
            xml.tag! 'Vendor', @options[:login]
            xml.tag! 'Partner', @options[:partner]
            if request_type == :recurring
              xml << body
            else
              xml.tag! 'Transactions' do
                xml.tag! 'Transaction' do
                  xml.tag! 'Verbosity', 'MEDIUM'
                  xml << body
                end
              end
            end
          end
          xml.tag! 'RequestAuth' do
            xml.tag! 'UserPass' do
              xml.tag! 'User', !@options[:user].blank? ? @options[:user] : @options[:login]
              xml.tag! 'Password', @options[:password]
            end
          end
        end
        xml.target!
      end
      
      def build_reference_request(action, money, authorization, options)
        xml = Builder::XmlMarkup.new :indent => 2
        xml.tag! TRANSACTIONS[action] do
          xml.tag! 'PNRef', authorization
        
          unless money.nil?
            xml.tag! 'Invoice' do
              xml.tag! 'TotalAmt', amount(money), 'Currency' => options[:currency] || currency(money)
            end
          end
        end
        
        xml.target!
      end

      def add_address(xml, tag, address, options)  
        return if address.nil?
        xml.tag! tag do
          xml.tag! 'Name', address[:name] unless options[:name].blank?
          xml.tag! 'Email', options[:email] unless options[:email].blank?
          xml.tag! 'Phone', address[:phone] unless address[:phone].blank?
          xml.tag! 'Address' do
            xml.tag! 'Street', address[:address1] unless address[:address1].blank?
            xml.tag! 'City', address[:city] unless address[:city].blank?
            xml.tag! 'State', address[:state].blank? ? "N/A" : address[:state]
            xml.tag! 'Country', address[:country] unless address[:country].blank?
            xml.tag! 'Zip', address[:zip] unless address[:zip].blank?
          end
        end
      end
          
      def parse(data)
        response = {}
        xml = REXML::Document.new(data)
        root = REXML::XPath.first(xml, "//ResponseData")
        
        # REXML::XPath in Ruby 1.8.6 is now unable to match nodes based on their attributes
        tx_result = REXML::XPath.first(root, "//TransactionResult")
        
        if tx_result && tx_result.attributes['Duplicate'] == "true"
          response[:duplicate] = true 
        end
        
        root.elements.to_a.each do |node|
          parse_element(response, node)
        end

        response
      end
      
      def parse_element(response, node)
        if node.has_elements?
          node.elements.each{|e| parse_element(response, e) }
        elsif node.name == 'ExtData'
          response[node.attributes['Name'].underscore.to_sym] = node.attributes['Value']
        else
          response[node.name.underscore.to_sym] = node.text
        end
      end
      
      def build_headers(content_length)
        {
          "Content-Type" => "text/xml",
          "Content-Length" => content_length.to_s,
      	  "X-VPS-Timeout" => timeout.to_s,
      	  "X-VPS-VIT-Integration-Product" => "ActiveMerchant",
      	  "X-VPS-VIT-Runtime-Version" => RUBY_VERSION,
      	  "X-VPS-Request-ID" => generate_unique_id
    	  }
    	end
    	
    	def commit(request_body, request_type = nil)
        request = build_request(request_body, request_type)
        headers = build_headers(request.size)
        
        if result = test_result_from_cc_number(parse_credit_card_number(request))
          return result
        end
      
    	  url = test? ? TEST_URL : LIVE_URL
    	  data = ssl_post(url, request, headers)
    	  
    	  @response = parse(data)
    	  
    	  success = @response[:result] == "0"
    	  message = @response[:message]
    	  
    	  build_response(success, message, @response,
    	    :test => test?,
    	    :authorization => @response[:pn_ref] || @response[:rp_ref]
        )
      end
      
      def parse_credit_card_number(request)
        xml = REXML::Document.new(request)
        card_number = REXML::XPath.first(xml, '//Tender/Card/CardNum')
        card_number && card_number.text
      end
    end
  end
end