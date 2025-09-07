class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :require_login
  before_action :log_params
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found


  def logged_in?
    current_user.present?
  end
  allow_browser versions: :modern
  def current_user
    @current_user ||= Current.session&.user
  end
  def after_authentication_url
    root_path
  end
  private
    def require_login
        unless logged_in?
          flash[:error] = "You must be logged in to access this section"
          redirect_to new_session_path # halts request cycle
        end
    end
  def log_params
    Rails.logger.error ">>> #{controller_name}##{action_name} params: #{params.to_unsafe_h}"
  end

  def render_not_found
  render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end
end
