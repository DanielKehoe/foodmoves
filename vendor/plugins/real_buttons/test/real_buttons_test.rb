require 'rubygems'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/real_buttons'
require 'action_view/helpers/tag_helper'
require 'active_support/core_ext/hash/keys'

class RealButtonsTest < Test::Unit::TestCase

  include ActionView::Helpers::TagHelper
  include ActiveSupport::CoreExtensions::Hash::Keys
  include RealButtons

  # Replace this with your real tests.
  def test_real_button_to
    output = real_button_to "Delete", "/submit/path/for/form", :method => :delete, :class => "delete", :title => "Delete"
    assert_equal "<form method=\"post\" action=\"/submit/path/for/form\" class=\"real-button-to\><div><input name=\"_method\" type=\"hidden\" value=\"delete\" /><button class=\"delete\" title=\"Delete\" type=\"submit\">Delete</button></div></form>", output
    output = real_button_to "Submit", "/submit/path/for/form"
    assert_equal "<form method=\"post\" action=\"/submit/path/for/form\" class=\"real-button-to\><div><button type=\"submit\">Submit</button></div></form>", output
    output = real_button_to "Action", "/submit/path/for/form", :class => "special"
    assert_equal "<form method=\"post\" action=\"/submit/path/for/form\" class=\"real-button-to\><div><button class=\"special\" type=\"submit\">Action</button></div></form>", output
  end
  
  def test_button_submit_tag
    output = button_submit_tag
    assert_equal "<button name=\"commit\" type=\"submit\">Save Changes</button>", output
    output = button_submit_tag "Update", :class => "testing"
    assert_equal "<button class=\"testing\" name=\"commit\" type=\"submit\">Update</button>", output

  end
end