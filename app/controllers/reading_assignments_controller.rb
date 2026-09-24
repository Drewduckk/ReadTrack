class ReadingAssignmentsController < ApplicationController
  before_action :require_authentication
  before_action :set_reading_assignment, only: %i[show edit update destroy read]

  def index
    @reading_assignments = policy_scope(ReadingAssignment).includes(:book, :teacher)
    authorize ReadingAssignment
  end

  def show
    authorize @reading_assignment
    @summaries = @reading_assignment.summaries.includes(:student).order(created_at: :desc)
    @reading_progresses = @reading_assignment.reading_progresses.includes(:student)
    @my_progress = current_user.reading_progresses.find_by(reading_assignment: @reading_assignment) if current_user.student?
  end

  def read
    authorize @reading_assignment, :read?
    @book = @reading_assignment.book

    max_visible_page = [@reading_assignment.released_until, @book.page_count].min
    requested_page = params[:page].to_i
    requested_page = 1 if requested_page < 1
    @current_page = [requested_page, max_visible_page].min
    @max_visible_page = max_visible_page

    @my_progress = current_user.reading_progresses.find_or_initialize_by(reading_assignment: @reading_assignment) if current_user.student?
    @my_summaries = @reading_assignment.summaries.where(student: current_user) if current_user.student?
  end

  def new
    @reading_assignment = ReadingAssignment.new(released_until: 10)
    authorize @reading_assignment
  end

  def create
    @reading_assignment = current_user.reading_assignments.build(reading_assignment_params)
    authorize @reading_assignment

    ReadingAssignment.transaction do
      if @reading_assignment.save
        redirect_to @reading_assignment, notice: "Leseauftrag erfolgreich erstellt."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    authorize @reading_assignment
  end

  def update
    authorize @reading_assignment

    ReadingAssignment.transaction do
      @reading_assignment.lock!
      if @reading_assignment.update(reading_assignment_params)
        redirect_to @reading_assignment, notice: "Leseauftrag wurde aktualisiert (Freigegeben bis Seite #{@reading_assignment.released_until})."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    authorize @reading_assignment
    @reading_assignment.destroy
    redirect_to reading_assignments_path, notice: "Leseauftrag wurde gelöscht."
  end

  private

  def set_reading_assignment
    @reading_assignment = ReadingAssignment.find(params[:id])
  end

  def reading_assignment_params
    params.require(:reading_assignment).permit(:book_id, :released_until)
  end
end
