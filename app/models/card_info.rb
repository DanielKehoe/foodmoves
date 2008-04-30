# == Schema Information
# Schema version: 111
#
# Table name: tokens
#
#  id              :integer(11)   not null, primary key
#  tag             :string(255)   
#  first_name      :string(255)   
#  last_name       :string(255)   
#  month           :string(255)   
#  year            :string(255)   
#  region          :string(255)   
#  country         :string(255)   
#  admin_area      :string(255)   
#  locality        :string(255)   
#  thoroughfare    :string(255)   
#  postal_code     :string(255)   
#  created_at      :datetime      
#  updated_at      :datetime      
#  organization_id :integer(11)   
#  crypted_number  :text          
#  last_digits     :string(4)     
#

class CardInfo < ActiveRecord::Base
  
  require 'openssl'  
  require 'base64'
  
  set_table_name "tokens"
  belongs_to :organization
  
  attr_accessor :number
  
  before_save :encrypt_number
  
  def self.all_tags
    %w{ Visa Mastercard Amex Discover}
  end

  def self.all_months
    %w{ 01 02 03 04 05 06 07 08 09 10 11 12 }
  end
  
  def self.all_years
    y1 = Time.now.year
    [ y1, y1+1, y1+2, y1+3, y1+4, y1+5, y1+6, y1+7, y1+8, y1+9 ]
  end
  
  def creditcard(pass_phrase)
    if self.crypted_number
      ActiveMerchant::Billing::CreditCard.new(
        :type       => self.tag,
        :number     => decrypt_number(pass_phrase),
        :month      => self.month.to_i,
        :year       => self.year.to_i,
        :first_name => self.first_name,
        :last_name  => self.last_name
      )
    else
      ActiveMerchant::Billing::CreditCard.new
    end
  end
  
  # Show the card number, with all but last 4 numbers replaced with "X". (XXXX-XXXX-XXXX-4338)
  def display_number
    "XXXX-XXXX-XXXX-#{self.last_digits}"
  end
  
  def missing?
    false
    if self.tag.blank? or self.number.blank? or self.first_name.blank? or self.month.blank? or self.year.blank?
      true 
    end
  end

  def decrypt_number(pass_phrase)
    raise Exception, "pass phrase is blank" if pass_phrase.blank?
    begin
      private_key_file = 'private.pem';
      private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file),pass_phrase)
      number = private_key.private_decrypt(Base64.decode64(self.crypted_number))
    rescue Exception => e
      message = "\n CardInfo failed to decrypt number: #{e.message} \n\n"
      logger.error(message) 
      raise Exception, message
    end
    #number = '4222222222222' # Authorize.net test card, error-producing
    #number = '4007000000027' # Authorize.net test card, non-error-producing
    #number = '4242424242424242'
  end
  
  def encrypt_number
    return if number.blank?
    self.last_digits = number.to_s.last(4)
    begin
      public_key_file = 'public.pem';
      public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
      self.crypted_number = Base64.encode64(public_key.public_encrypt(self.number))
    rescue Exception => e
      message = "\n CardInfo failed to encrypt number: #{e.message} \n\n"
      logger.error(message) 
      raise Exception, message
    end
  end
end
