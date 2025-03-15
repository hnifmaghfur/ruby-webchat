require "test_helper"

class V1ControllerTest < ActionDispatch::IntegrationTest
  test "should get users" do
    get v1_users_url
    assert_response :success
  end
end
