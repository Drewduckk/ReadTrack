require "test_helper"

class ReadingAssignmentTest < ActiveSupport::TestCase
  def setup
    @teacher = users(:teacher)
    @book = books(:one)
  end

  test "valid reading assignment saves" do
    assignment = ReadingAssignment.new(
      book: @book,
      teacher: @teacher,
      released_until: 15
    )
    assert assignment.valid?
    assert assignment.save
  end

  test "reading assignment invalid without positive released_until" do
    assignment = ReadingAssignment.new(
      book: @book,
      teacher: @teacher,
      released_until: 0
    )
    assert_not assignment.valid?
    assert assignment.errors[:released_until].present?
  end

  test "reading assignment records papertrail versions on update" do
    assignment = ReadingAssignment.create!(
      book: @book,
      teacher: @teacher,
      released_until: 10
    )
    assert_equal 1, assignment.versions.count

    assignment.update!(released_until: 25)
    assert_equal 2, assignment.versions.count
    assert_equal "update", assignment.versions.last.event
  end
end
