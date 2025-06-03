class PagesController < ApplicationController
  def home
    per_page = 10
    page = params.fetch(:page, 1).to_i
    @current_page = page
    keyword_offset = (page - 1) * per_page
    project_offset = (page - 1) * 3

    @keywords = Keyword.joins(:project).where(projects: { user_id: session[:current_user_id] }).offset(keyword_offset).limit(per_page)
    @totalKeywords = Keyword.joins(:project).where(projects: { user_id: session[:current_user_id] }).count

    @total_keyword_pages = (Keyword.count / per_page.to_f).ceil

    @projects = Project.where(projects: { user_id: session[:current_user_id] }).offset(project_offset).limit(3)
    @total_project_pages = (@projects .count / 3.to_f).ceil
  end
end
