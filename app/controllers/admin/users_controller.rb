class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update]

  def index
    authorize User

    @users = User.all
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email_address, :role)
  end
end
