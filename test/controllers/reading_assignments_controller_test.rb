require "test_helper"

class ReadingAssignmentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher)
    @other_teacher = users(:other_teacher)
    @student = users(:student_one)
    @assignment = reading_assignments(:one) # teacher is @teacher
    @book = books(:two)
  end

  test "teacher can create reading assignment" do
    sign_in_as(@teacher)
    assert_difference("ReadingAssignment.count", 1) do
      post reading_assignments_url, params: {
        reading_assignment: {
          book_id: @book.id,
          released_until: 15
        }
      }
    end
    assert_redirected_to reading_assignment_url(ReadingAssignment.last)
    assert_equal @teacher, ReadingAssignment.last.teacher
  end

  test "student cannot create reading assignment" do
    sign_in_as(@student)
    assert_no_difference("ReadingAssignment.count") do
      post reading_assignments_url, params: {
        reading_assignment: {
          book_id: @book.id,
          released_until: 15
        }
      }
    end
    assert_redirected_to root_url
  end

  test "teacher can advance released_until with locking and transaction" do
    sign_in_as(@teacher)
    patch reading_assignment_url(@assignment), params: {
      reading_assignment: { released_until: 30 }
    }
    assert_redirected_to reading_assignment_url(@assignment)
    assert_equal 30, @assignment.reload.released_until
  end

  test "other teacher cannot update assignment" do
    sign_in_as(@other_teacher)
    patch reading_assignment_url(@assignment), params: {
      reading_assignment: { released_until: 50 }
    }
    assert_redirected_to root_url
    assert_not_equal 50, @assignment.reload.released_until
  end

  test "student can access read page" do
    sign_in_as(@student)
    get read_reading_assignment_url(@assignment)
    assert_response :success
  end
end
