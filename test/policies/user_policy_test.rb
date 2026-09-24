require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  def setup
    @admin = users(:admin)
    @teacher = users(:teacher)
    @student = users(:student_one)
  end

  test "admin can index users" do
    assert UserPolicy.new(@admin, User).index?
  end

  test "teacher and student cannot index users" do
    assert_not UserPolicy.new(@teacher, User).index?
    assert_not UserPolicy.new(@student, User).index?
  end

  test "admin can edit and update users" do
    assert UserPolicy.new(@admin, @student).edit?
    assert UserPolicy.new(@admin, @student).update?
  end

  test "teacher and student cannot edit other users" do
    assert_not UserPolicy.new(@teacher, @student).edit?
    assert_not UserPolicy.new(@student, @teacher).update?
  end
end
