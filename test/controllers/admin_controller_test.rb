require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get users" do
    get admin_users_url
    assert_response :success
  end

  test "should get delete_user" do
    get admin_delete_user_url
    assert_response :success
  end

end
