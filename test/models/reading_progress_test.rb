require "test_helper"

class ReadingProgressTest < ActiveSupport::TestCase
  def setup
    @student = users(:student_one)
    @assignment = reading_assignments(:two)
  end

  test "valid reading progress saves" do
    progress = ReadingProgress.new(
      student: @student,
      reading_assignment: @assignment,
      current_page: 5
    )
    assert progress.valid?
    assert progress.save
  end

  test "reading progress must not have negative page" do
    progress = ReadingProgress.new(
      student: @student,
      reading_assignment: @assignment,
      current_page: -1
    )
    assert_not progress.valid?
  end

  test "reading progress records papertrail version" do
    progress = ReadingProgress.create!(
      student: @student,
      reading_assignment: @assignment,
      current_page: 5
    )
    assert_equal 1, progress.versions.count
  end
end
