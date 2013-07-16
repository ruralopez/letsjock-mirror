require 'test_helper'

class JavascriptsControllerTest < ActionController::TestCase
  test "should get countries" do
    get :countries
    assert_response :success
  end

end
