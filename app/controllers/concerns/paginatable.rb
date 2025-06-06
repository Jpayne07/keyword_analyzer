module Paginatable
  extend ActiveSupport::Concern

  def current_page(per_page = 10)
    params.fetch(:page, 1).to_i
  end

  def paginate_keywords(per_page = 10)
    offset = (current_page(per_page) - 1) * per_page
    {
      data: Keyword.joins(:project).where(projects: { user_id: session[:current_user_id] }).offset(offset).limit(per_page),
      total: Keyword.joins(:project).where(projects: { user_id: session[:current_user_id] }).count,
      total_pages: (Keyword.count / per_page.to_f).ceil
    }
  end

  def paginate_projects(per_page = 3)
    offset = (current_page(per_page) - 1) * per_page
    {
      data: Project.where(user_id: session[:current_user_id]).offset(offset).limit(per_page),
      total_pages: (Project.where(user_id: session[:current_user_id]).count / per_page.to_f).ceil
    }
  end

  def paginate_project_insights(per_page = 6)
    offset = (current_page(per_page) - 1) * per_page
    {
      data: Project.where(user_id: session[:current_user_id]).offset(offset).limit(per_page),
      total_pages: (Project.where(user_id: session[:current_user_id]).count / per_page.to_f).ceil
    }
  end
end
