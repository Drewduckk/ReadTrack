require "test_helper"

class SummaryPolicyTest < ActiveSupport::TestCase
  def setup
    @teacher = users(:teacher)
    @other_teacher = users(:other_teacher)
    @student_one = users(:student_one)
    @student_two = users(:student_two)
    @admin = users(:admin)
    @summary = summaries(:one) # student is student_one, assignment teacher is @teacher
  end

  test "students and admins can create summaries" do
    assert SummaryPolicy.new(@student_one, Summary.new).create?
    assert SummaryPolicy.new(@admin, Summary.new).create?
  end

  test "teachers cannot create summaries" do
    assert_not SummaryPolicy.new(@teacher, Summary.new).create?
  end

  test "student owner can view and edit own summary" do
    assert SummaryPolicy.new(@student_one, @summary).show?
    assert SummaryPolicy.new(@student_one, @summary).update?
    assert SummaryPolicy.new(@student_one, @summary).destroy?
  end

  test "other student cannot edit another students summary" do
    assert_not SummaryPolicy.new(@student_two, @summary).update?
    assert_not SummaryPolicy.new(@student_two, @summary).destroy?
  end

  test "assignment teacher can view summary but cannot edit it" do
    assert SummaryPolicy.new(@teacher, @summary).show?
    assert_not SummaryPolicy.new(@teacher, @summary).update?
  end

  test "unrelated teacher cannot view summary" do
    assert_not SummaryPolicy.new(@other_teacher, @summary).show?
  end

  test "admin can view and edit any summary" do
    assert SummaryPolicy.new(@admin, @summary).show?
    assert SummaryPolicy.new(@admin, @summary).update?
  end
end
