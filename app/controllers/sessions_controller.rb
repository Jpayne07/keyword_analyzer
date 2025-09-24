# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: lambda {
    redirect_to new_session_url, alert: 'Try again later.'
  }
  skip_before_action :require_login, only: %i[new create]
  before_action :redirect_if_logged_in, only: [:new]

  def new; end

  def create
    if (user = User.authenticate_by(params.permit(:email_address, :password)))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: 'Try another email address or password.'
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def redirect_if_logged_in
    redirect_to after_authentication_url, status: :see_other if authenticated?
  end
end
