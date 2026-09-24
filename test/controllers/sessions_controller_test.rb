require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    post session_url, params: { email_address: users(:teacher).email_address, password: "password123456" }
    assert_redirected_to dashboard_url
  end

  test "should fail session with invalid password" do
    post session_url, params: { email_address: users(:teacher).email_address, password: "wrong" }
    assert_response :unprocessable_entity
  end

  test "should destroy session" do
    sign_in_as(users(:teacher))
    delete session_url
    assert_redirected_to new_session_url
  end
end
