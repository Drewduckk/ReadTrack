require "test_helper"

class SummariesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher)
    @student_one = users(:student_one)
    @student_two = users(:student_two)
    @assignment = reading_assignments(:one) # released_until: 20
    @summary_one = summaries(:one) # student_one, pages 1-15
  end

  test "student can create summary within released_until" do
    sign_in_as(@student_one)
    assert_difference("Summary.count", 1) do
      post reading_assignment_summaries_url(@assignment), params: {
        summary: {
          page_from: 1,
          page_to: 20,
          content: "Spannender Abschnitt."
        }
      }
    end
    new_summary = Summary.last
    assert_redirected_to summary_url(new_summary)
    assert_equal @student_one, new_summary.student
  end

  test "student cannot create summary exceeding released_until" do
    sign_in_as(@student_one)
    assert_no_difference("Summary.count") do
      post reading_assignment_summaries_url(@assignment), params: {
        summary: {
          page_from: 1,
          page_to: 25, # exceeds released_until 20
          content: "Ich versuche weiter zu schreiben als erlaubt."
        }
      }
    end
    assert_response :unprocessable_entity
    assert_includes response.body, "cannot exceed the released range"
  end

  test "student can update own summary" do
    sign_in_as(@student_one)
    patch summary_url(@summary_one), params: {
      summary: { content: "Ueberarbeitete Fassung." }
    }
    assert_redirected_to summary_url(@summary_one)
    assert_equal "Ueberarbeitete Fassung.", @summary_one.reload.content
  end

  test "student cannot update another students summary" do
    sign_in_as(@student_two)
    patch summary_url(@summary_one), params: {
      summary: { content: "Gefälschte Fassung von fremdem Schueler." }
    }
    assert_redirected_to root_url
    assert_not_equal "Gefälschte Fassung von fremdem Schueler.", @summary_one.reload.content
  end

  test "teacher can view summary for their assignment" do
    sign_in_as(@teacher)
    get summary_url(@summary_one)
    assert_response :success
  end

  test "teacher cannot edit student summary" do
    sign_in_as(@teacher)
    patch summary_url(@summary_one), params: {
      summary: { content: "Lehrperson ändert Text." }
    }
    assert_redirected_to root_url
    assert_not_equal "Lehrperson ändert Text.", @summary_one.reload.content
  end
end
