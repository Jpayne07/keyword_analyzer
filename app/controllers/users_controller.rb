# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]
  skip_before_action :require_login, only: %i[new create]
  allow_unauthenticated_access only: %i[new create]
  before_action :set_user, only: %i[show edit update destroy]
  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      terminate_session if Current.session.present?
      start_new_session_for(@user)
      redirect_to after_authentication_url, notice: 'Account created and logged in!'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: %i[name email_address password password_confirmation])
  end
end

# def authorize_user!
#   redirect_to root_path, alert: "Not authorized." unless @user == current_user
# end
