require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/home_controller'

# Re-raise errors caught by the controller.
class Admin::HomeController; def rescue_action(e) raise e end; end

class Admin::HomeControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
