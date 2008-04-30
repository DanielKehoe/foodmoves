require 'active_support'

# RealButtons
module RealButtons

    def real_button_to(name, options = {}, html_options = {})
      html_options = html_options.stringify_keys
      convert_boolean_attributes!(html_options, %w( disabled ))


      method_tag = ''
      if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
          method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
      end

      form_method = method.to_s == 'get' ? 'get' : 'post'

      if confirm = html_options.delete("confirm")
          html_options["onclick"] = "return #{confirm_javascript_function(confirm)};"
      end

      url = options.is_a?(String) ? options : self.url_for(options)
      name ||= url

      html_options.merge!("type" => "submit")

      "<form method=\"#{form_method}\" action=\"#{escape_once url}\" class=\"real-button-to\"><div>" + method_tag + content_tag(:button, name, html_options ) + "</div></form>"
    end

    def button_submit_tag(value = "Save Changes", options = {})
      options.stringify_keys!

      # included although you should be using ujs4rails.org
      if disable_with = options.delete("disable_with")
        options["onclick"] = "this.disabled=true;this.value='#{disable_with}';this.form.submit();#{options["onclick"]}"
      end

      content_tag :button, value, {"name" => "commit", "type" => "submit" }.update(options.stringify_keys)
    end

  end
  