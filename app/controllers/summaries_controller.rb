class SummariesController < ApplicationController
  before_action :require_authentication
  before_action :set_reading_assignment, only: %i[index new create]
  before_action :set_summary, only: %i[show edit update destroy]

  def index
    @summaries = if @reading_assignment
      policy_scope(@reading_assignment.summaries)
    else
      policy_scope(Summary)
    end
    authorize Summary
  end

  def show
    authorize @summary
  end

  def new
    @summary = @reading_assignment.summaries.build(student: current_user, page_from: 1, page_to: @reading_assignment.released_until)
    authorize @summary
  end

  def create
    @summary = @reading_assignment.summaries.build(summary_params)
    @summary.student = current_user
    authorize @summary

    Summary.transaction do
      @reading_assignment.lock!
      if @summary.save
        redirect_to @summary, notice: "Zusammenfassung erfolgreich gespeichert."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    authorize @summary
  end

  def update
    authorize @summary

    Summary.transaction do
      @summary.reading_assignment.lock!
      if @summary.update(summary_params)
        redirect_to @summary, notice: "Zusammenfassung erfolgreich aktualisiert."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    authorize @summary
    assignment = @summary.reading_assignment
    @summary.destroy
    redirect_to reading_assignment_path(assignment), notice: "Zusammenfassung wurde gelöscht."
  end

  private

  def set_reading_assignment
    @reading_assignment = ReadingAssignment.find(params[:reading_assignment_id]) if params[:reading_assignment_id]
  end

  def set_summary
    @summary = Summary.find(params[:id])
  end

  def summary_params
    params.require(:summary).permit(:page_from, :page_to, :content)
  end
end
