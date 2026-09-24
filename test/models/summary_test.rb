require "test_helper"

class SummaryTest < ActiveSupport::TestCase
  def setup
    @assignment = reading_assignments(:one) # released_until = 20
    @student = users(:student_one)
  end

  test "valid summary saves successfully" do
    summary = Summary.new(
      reading_assignment: @assignment,
      student: @student,
      page_from: 1,
      page_to: 20,
      content: "Gute Zusammenfassung der ersten 20 Seiten."
    )
    assert summary.valid?
    assert summary.save
  end

  test "summary exceeding released_until is invalid" do
    summary = Summary.new(
      reading_assignment: @assignment,
      student: @student,
      page_from: 1,
      page_to: 25, # exceeds released_until (20)
      content: "Ich habe zu weit gelesen."
    )
    assert_not summary.valid?
    assert_includes summary.errors[:page_to].to_sentence, "kann nicht über den freigegebenen Bereich"
  end

  test "summary with page_to smaller than page_from is invalid" do
    summary = Summary.new(
      reading_assignment: @assignment,
      student: @student,
      page_from: 10,
      page_to: 5,
      content: "Ungueltige Reihenfolge."
    )
    assert_not summary.valid?
    assert_includes summary.errors[:page_to].to_sentence, "grösser oder gleich 'Seite von'"
  end

  test "summary with page_from less than 1 is invalid" do
    summary = Summary.new(
      reading_assignment: @assignment,
      student: @student,
      page_from: 0,
      page_to: 10,
      content: "Ungueltige Startseite."
    )
    assert_not summary.valid?
    assert summary.errors[:page_from].present?
  end

  test "summary records audit versions with papertrail" do
    summary = Summary.create!(
      reading_assignment: @assignment,
      student: @student,
      page_from: 1,
      page_to: 10,
      content: "Erste Zusammenfassung."
    )
    assert_equal 1, summary.versions.count
    assert_equal "create", summary.versions.last.event

    summary.update!(content: "Aktualisierte Zusammenfassung.")
    assert_equal 2, summary.versions.count
    assert_equal "update", summary.versions.last.event
  end
end
