require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user with valid parameters" do
    assert_difference("User.count", 1) do
      post signup_url, params: {
        user: {
          name: "Neuer Schueler",
          email_address: "neuerschueler@example.com",
          password: "password123456",
          password_confirmation: "password123456"
        }
      }
    end
    assert_redirected_to dashboard_path
  end

  test "should create teacher account when role is set to teacher" do
    assert_difference("User.count", 1) do
      post signup_url, params: {
        user: {
          name: "Neue Lehrperson",
          email_address: "neuelehrperson@example.com",
          password: "password123456",
          password_confirmation: "password123456",
          role: "teacher"
        }
      }
    end
    assert_redirected_to dashboard_path
    assert_equal "teacher", User.last.role
  end

  test "cannot self-register as admin via role param" do
    assert_difference("User.count", 1) do
      post signup_url, params: {
        user: {
          name: "Angreifer",
          email_address: "angreifer@example.com",
          password: "password123456",
          password_confirmation: "password123456",
          role: "admin"
        }
      }
    end
    assert_redirected_to dashboard_path
    assert_equal "student", User.last.role, "role param must not allow self-promotion to admin"
  end

  test "unknown role value falls back to student" do
    assert_difference("User.count", 1) do
      post signup_url, params: {
        user: {
          name: "Verwirrter Nutzer",
          email_address: "verwirrt@example.com",
          password: "password123456",
          password_confirmation: "password123456",
          role: "superuser"
        }
      }
    end
    assert_equal "student", User.last.role
  end
end
