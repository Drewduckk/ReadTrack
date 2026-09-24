require "test_helper"

class BookPolicyTest < ActiveSupport::TestCase
  def setup
    @teacher = users(:teacher)
    @student = users(:student_one)
    @admin = users(:admin)
    @book = books(:one)
  end

  test "logged in users can view books" do
    assert BookPolicy.new(@student, @book).show?
    assert BookPolicy.new(@teacher, @book).show?
  end

  test "teachers and admins can create and update books" do
    assert BookPolicy.new(@teacher, @book).create?
    assert BookPolicy.new(@teacher, @book).update?
    assert BookPolicy.new(@admin, @book).create?
    assert BookPolicy.new(@admin, @book).update?
  end

  test "students cannot create or update books" do
    assert_not BookPolicy.new(@student, @book).create?
    assert_not BookPolicy.new(@student, @book).update?
  end

  test "only admin can destroy books" do
    assert BookPolicy.new(@admin, @book).destroy?
    assert_not BookPolicy.new(@teacher, @book).destroy?
    assert_not BookPolicy.new(@student, @book).destroy?
  end
end
