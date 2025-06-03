class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  def current_user
      @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
  end
end
