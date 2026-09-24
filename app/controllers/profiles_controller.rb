class ProfilesController < ApplicationController
  before_action :require_authentication
  skip_before_action :require_authentication, only: :confirm_email

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user

    unless @user.authenticate(params[:current_password])
      @user.errors.add(:current_password, "is incorrect")
      return render :edit_password, status: :unprocessable_entity
    end

    if @user.update(password_params)
      redirect_to profile_path, notice: "Password changed successfully."
    else
      render :edit_password, status: :unprocessable_entity
    end
  end

  # Schritt 1: neue Adresse anfordern. email_address bleibt unveraendert, bis
  # der Bestaetigungslink angeklickt wird (#confirm_email).
  def edit_email
    @user = current_user
  end

  def update_email
    @user = current_user
    new_email_address = params[:email_address].to_s

    ActiveRecord::Base.transaction do
      @user.update!(
        email_change: new_email_address,
        email_change_token: SecureRandom.urlsafe_base64(32)
      )

      # Fuer die Projektarbeit genuegt es, den Bestaetigungslink zu loggen,
      # statt effektiv eine E-Mail zu versenden.
      Rails.logger.debug "[Email confirmation] Link for #{new_email_address}: #{confirm_profile_email_url(token: @user.email_change_token)}"
    end

    redirect_to profile_path, notice: "A confirmation link was sent to #{new_email_address} (see server log)."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_profile_email_path, alert: e.record.errors.full_messages.to_sentence
  end

  # Schritt 2: Klick auf den Bestaetigungslink macht die neue Adresse aktiv.
  # Bewusst OHNE Login-Zwang, da der Link auf einem anderen Geraet/E-Mail-
  # Programm geoeffnet werden kann.
  def confirm_email
    user = User.find_by(email_change_token: params[:token])

    if user
      user.update!(email_address: user.email_change, email_change: nil, email_change_token: nil)
      redirect_to profile_path, notice: "Your email address has been confirmed."
    else
      redirect_to root_path, alert: "This confirmation link is invalid or has already been used."
    end
  end

  private

  def profile_params
    params.expect(user: [:name])
  end

  def password_params
    params.expect(
      user: [:password, :password_confirmation]
    )
  end
end
