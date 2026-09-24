require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user has student role by default" do
    user = User.new(
      name: "Neuer User",
      email_address: "neu@example.com",
      password: "password123456"
    )
    assert user.student?
  end

  test "user can be set to teacher role" do
    user = User.new(
      name: "Neue Lehrperson",
      email_address: "lehrperson@example.com",
      password: "password123456",
      role: :teacher
    )
    assert user.teacher?
    assert_not user.student?
  end

  test "user can be set to admin role" do
    user = User.new(
      name: "Admin",
      email_address: "admin_new@example.com",
      password: "password123456",
      role: :admin
    )
    assert user.admin?
  end

  test "user invalid without name" do
    user = User.new(email_address: "test@example.com", password: "password123456")
    assert_not user.valid?
    assert user.errors[:name].present?
  end

  test "user invalid with short password" do
    user = User.new(name: "Test", email_address: "test2@example.com", password: "short")
    assert_not user.valid?
    assert user.errors[:password].present?
  end

  test "user invalid with duplicate email address" do
    existing = users(:teacher)
    user = User.new(
      name: "Duplikat",
      email_address: existing.email_address,
      password: "password123456"
    )
    assert_not user.valid?
    assert user.errors[:email_address].present?
  end
end
