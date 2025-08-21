class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]
  skip_before_action :require_login, only: [ :new, :create ]
  allow_unauthenticated_access only: [ :new, :create ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      terminate_session if Current.session.present?
      start_new_session_for(@user)
      redirect_to after_authentication_url, notice: "Account created and logged in!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: "User was successfully destroyed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end


# def authorize_user!
#   redirect_to root_path, alert: "Not authorized." unless @user == current_user
# end
