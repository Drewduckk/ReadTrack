class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :set_current_session
  before_action :set_paper_trail_whodunnit

  helper_method :current_user

  def user_for_paper_trail
    current_user&.id
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_current_session
    Current.session = Session.find_by(id: session[:user_session_id])
  end

  def current_user
    Current.user
  end

  def require_authentication
    redirect_to new_session_path, alert: "Please sign in first." unless current_user
  end

  def user_not_authorized
    redirect_back fallback_location: root_path, alert: "You are not authorized to perform this action."
  end
end