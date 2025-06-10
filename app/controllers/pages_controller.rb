class PagesController < ApplicationController
  include Paginatable

  def home
    @kw_table_styling = "home_kw_table"
    @current_page = current_page(10)
    keyword_data = paginate_keywords(10, nil)
    @keywords = keyword_data[:data]
    @total_keyword_pages = keyword_data[:total_pages]
    @projects = paginate_projects(3)[:data]
    @total_pages= paginate_projects(3)[:total_pages]
    @projectsInsights = paginate_project_insights[:data]
    @total_project_pages = paginate_project_insights[:total_pages]
  end
end
