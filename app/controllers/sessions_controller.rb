class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate_by(
      email_address: params[:email_address],
      password: params[:password]
    )

    if user
      user_session = user.sessions.create!
      session[:user_session_id] = user_session.id
      Current.session = user_session

      redirect_to dashboard_path, notice: "Signed in successfully."
    else
      flash.now[:alert] = "Invalid email address or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Current.session&.destroy
    reset_session

    redirect_to new_session_path, notice: "Signed out successfully."
  end
end