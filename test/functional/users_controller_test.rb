require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get forgot_password" do
    get :forgot_password
    assert_response :success
  end

end
