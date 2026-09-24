class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    if current_user.teacher?
      @reading_assignments = current_user.reading_assignments.includes(:book, :summaries)
      @books = Book.all
    elsif current_user.student?
      @reading_assignments = ReadingAssignment.includes(:book, :teacher).all
      @my_summaries = current_user.summaries.includes(reading_assignment: :book).order(created_at: :desc)
      @my_progresses = current_user.reading_progresses.index_by(&:reading_assignment_id)
    else # admin
      @reading_assignments = ReadingAssignment.includes(:book, :teacher).all
      @books = Book.all
      @my_summaries = Summary.includes(:student, reading_assignment: :book).order(created_at: :desc).limit(10)
    end

    @recent_activities = scoped_activities.order(created_at: :desc).limit(15)
  end

  private

  # Jede Rolle sieht nur Aktivitaet, die sie auch ueber die jeweiligen
  # Policies einsehen duerfte: Admin alles, Lehrperson nur zu eigenen
  # Leseauftraegen (inkl. der Zusammenfassungen/Fortschritte ihrer
  # Klasse), Schueler nur die eigenen Zusammenfassungen/Fortschritte.
  def scoped_activities
    return PaperTrail::Version.all if current_user.admin?

    if current_user.teacher?
      assignment_ids = current_user.reading_assignments.ids
      summary_ids = Summary.where(reading_assignment_id: assignment_ids).ids
      progress_ids = ReadingProgress.where(reading_assignment_id: assignment_ids).ids

      PaperTrail::Version.where(item_type: "ReadingAssignment", item_id: assignment_ids)
        .or(PaperTrail::Version.where(item_type: "Summary", item_id: summary_ids))
        .or(PaperTrail::Version.where(item_type: "ReadingProgress", item_id: progress_ids))
    else # student
      PaperTrail::Version.where(item_type: "Summary", item_id: current_user.summaries.ids)
        .or(PaperTrail::Version.where(item_type: "ReadingProgress", item_id: current_user.reading_progresses.ids))
    end
  end
end