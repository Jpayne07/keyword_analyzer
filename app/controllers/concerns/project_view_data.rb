# app/controllers/concerns/project_view_data.rb
module ProjectViewData
  extend ActiveSupport::Concern
  included do
    before_action :project_id_tables, only: [ :show ]
  end
  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_id_tables(kw_limit = 100, # allows for custom definition limit based on use
     ngram_limit = 20,
      url_limit = 20
      )
    @current_page = current_page(10)
    @top_urls = Keyword
      .where(project_id: @project.id)
      .group(:url)
      .select("url AS name, SUM(Search_Volume) AS search_volume, SUM(estimated_traffic) AS estimated_traffic, COUNT(name) AS kw_count")
      .order("search_volume DESC")
      .limit(url_limit)
    @top_categories = Keyword
      .where(project_id: @project.id)
      .group(:keyword_category)
      .select("keyword_category AS name, SUM(Search_Volume) AS search_volume, SUM(estimated_traffic) AS estimated_traffic, COUNT(name) AS kw_count")
      .order("search_volume DESC")
      .limit(5)
    @keywords = Keyword
      .where(project_id: @project.id)
      .limit(kw_limit)
    @projects = Project
      .where(user: current_user)
      .limit(100)
    @ngrams = Ngram
      .where(project: @project)
      .limit(ngram_limit)
      .order("weighted_frequency DESC")
  end
end
