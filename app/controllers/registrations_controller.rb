class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = allowed_role(params.dig(:user, :role))

    if @user.save
      redirect_to dashboard_path, notice: "Account successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Sicherheitshinweis: :role bewusst NICHT in user_params permitten.
  # Waere es Teil des Mass-Assignments, koennte man sich per Request
  # (z.B. role=admin) selbst zum Administrator machen, egal was das
  # <select> im Formular anzeigt. Stattdessen wird der Wert explizit
  # gegen eine Allowlist geprueft; alles ausser "teacher" faellt sicher
  # auf "student" zurueck.
  ALLOWED_SELF_REGISTRATION_ROLES = %w[student teacher].freeze

  def allowed_role(requested_role)
    ALLOWED_SELF_REGISTRATION_ROLES.include?(requested_role) ? requested_role : "student"
  end

  def user_params
    params.expect(user: [:name, :email_address, :password, :password_confirmation])
  end
end