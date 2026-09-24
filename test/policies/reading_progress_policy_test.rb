require "test_helper"

class ReadingProgressPolicyTest < ActiveSupport::TestCase
  def setup
    @student_one = users(:student_one)
    @student_two = users(:student_two)
    @teacher = users(:teacher)
    @progress = reading_progresses(:one) # belongs to student_one, assignment teacher is @teacher
  end

  test "student can update own reading progress" do
    assert ReadingProgressPolicy.new(@student_one, @progress).update?
  end

  test "other student cannot update another students progress" do
    assert_not ReadingProgressPolicy.new(@student_two, @progress).update?
  end

  test "teacher can view progress of their class" do
    assert ReadingProgressPolicy.new(@teacher, @progress).show?
  end
end
