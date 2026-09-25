class ReadingProgressesController < ApplicationController
  before_action :require_authentication
  before_action :set_reading_assignment

  def create
    save_progress
  end

  def update
    save_progress
  end

  private

  def set_reading_assignment
    @reading_assignment = ReadingAssignment.find(params[:reading_assignment_id])
  end

  def save_progress
    @progress = current_user.reading_progresses.find_or_initialize_by(reading_assignment: @reading_assignment)
    authorize @progress
    @progress.current_page = params.dig(:reading_progress, :current_page)

    if @progress.save
      redirect_back fallback_location: read_reading_assignment_path(@reading_assignment),
                    notice: "Reading progress saved: page #{@progress.current_page}."
    else
      redirect_back fallback_location: read_reading_assignment_path(@reading_assignment),
                    alert: "Error saving reading progress: #{@progress.errors.full_messages.to_sentence}"
    end
  end
end
