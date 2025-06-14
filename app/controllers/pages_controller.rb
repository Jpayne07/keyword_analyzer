class PagesController < ApplicationController
  include Paginatable

  def home
    @keywords = Keyword.limit(100).reorder("search_volume DESC")
    @kw_table_styling = "home_kw_table"
    @projects_table_styling = "home_projects_table"
    @current_page = current_page(10)
    @projects = paginate_projects(3)[:data]
    @total_pages= paginate_projects(3)[:total_pages]
    @projectsInsights = paginate_project_insights[:data]
    @total_project_pages = paginate_project_insights[:total_pages]
  end
end
