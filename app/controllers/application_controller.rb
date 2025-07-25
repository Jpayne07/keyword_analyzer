class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :require_login
   rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def logged_in?
       !current_user.nil?
  end
  allow_browser versions: :modern
def current_user
  @current_user ||= Current.session&.user
end

  private
    def require_login
        unless logged_in?
          flash[:error] = "You must be logged in to access this section"
          redirect_to new_session_url # halts request cycle

        end
    end
  def render_not_found
  render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
  end
end
