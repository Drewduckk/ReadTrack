require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to sign in when unauthenticated" do
    get dashboard_url
    assert_redirected_to new_session_url
  end

  test "should get index when authenticated as teacher" do
    sign_in_as(users(:teacher))
    get dashboard_url
    assert_response :success
  end

  test "should get index when authenticated as student" do
    sign_in_as(users(:student_one))
    get dashboard_url
    assert_response :success
  end

  test "student only sees own activity in the feed, not other students'" do
    Summary.create!(
      reading_assignment: reading_assignments(:one),
      student: users(:student_one),
      page_from: 1, page_to: 5,
      content: "Feed-Test eigene Zusammenfassung."
    )
    Summary.create!(
      reading_assignment: reading_assignments(:one),
      student: users(:student_two),
      page_from: 1, page_to: 9,
      content: "Feed-Test fremde Zusammenfassung."
    )

    sign_in_as(users(:student_one))
    get dashboard_url

    assert_response :success
    assert_includes response.body, "Seiten 1–5"
    assert_not_includes response.body, "Seiten 1–9"
  end

  test "teacher only sees activity for their own reading assignments" do
    reading_assignments(:one).update!(released_until: 30)   # belongs to :teacher
    reading_assignments(:two).update!(released_until: 99)   # belongs to :other_teacher

    sign_in_as(users(:teacher))
    get dashboard_url

    assert_response :success
    assert_includes response.body, "Seite 30"
    assert_not_includes response.body, "Seite 99"
  end
end
