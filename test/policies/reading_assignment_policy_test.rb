require "test_helper"

class ReadingAssignmentPolicyTest < ActiveSupport::TestCase
  def setup
    @teacher = users(:teacher)
    @other_teacher = users(:other_teacher)
    @student = users(:student_one)
    @admin = users(:admin)
    @assignment = reading_assignments(:one) # teacher is @teacher
  end

  test "anyone logged in can view and read assignment" do
    assert ReadingAssignmentPolicy.new(@student, @assignment).show?
    assert ReadingAssignmentPolicy.new(@student, @assignment).read?
    assert ReadingAssignmentPolicy.new(@teacher, @assignment).show?
  end

  test "teachers and admins can create assignments" do
    assert ReadingAssignmentPolicy.new(@teacher, ReadingAssignment.new).create?
    assert ReadingAssignmentPolicy.new(@admin, ReadingAssignment.new).create?
    assert_not ReadingAssignmentPolicy.new(@student, ReadingAssignment.new).create?
  end

  test "owner teacher can update assignment" do
    assert ReadingAssignmentPolicy.new(@teacher, @assignment).update?
  end

  test "other teacher cannot update assignment" do
    assert_not ReadingAssignmentPolicy.new(@other_teacher, @assignment).update?
  end

  test "students cannot update or destroy assignments" do
    assert_not ReadingAssignmentPolicy.new(@student, @assignment).update?
    assert_not ReadingAssignmentPolicy.new(@student, @assignment).destroy?
  end

  test "admin can update and destroy assignments" do
    assert ReadingAssignmentPolicy.new(@admin, @assignment).update?
    assert ReadingAssignmentPolicy.new(@admin, @assignment).destroy?
  end
end
