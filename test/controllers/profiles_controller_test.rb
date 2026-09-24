require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect show when unauthenticated" do
    get profile_url
    assert_redirected_to new_session_url
  end

  test "should get show when authenticated" do
    sign_in_as(users(:student_one))
    get profile_url
    assert_response :success
  end

  test "should get edit when authenticated" do
    sign_in_as(users(:student_one))
    get edit_profile_url
    assert_response :success
  end

  test "should update profile name" do
    sign_in_as(users(:student_one))
    patch profile_url, params: { user: { name: "Max Aktualisiert" } }
    assert_redirected_to profile_url
    assert_equal "Max Aktualisiert", users(:student_one).reload.name
  end
end
