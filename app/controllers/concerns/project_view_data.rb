# app/controllers/concerns/project_view_data.rb
module ProjectViewData
  extend ActiveSupport::Concern

  included do
    before_action :set_project, only: [ :show ]
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_id_url_table
    @current_page = current_page(10)
    keyword_data = paginate_keywords(10, @project.id)
    @top_urls = Keyword
      .where(project_id: @project.id)
      .group(:url)
      # !!!url as name is hacky, there is probably a better solution...need to revisit
      .select("url AS name, SUM(Search_Volume) AS search_volume, SUM(estimated_traffic) AS est_traffic")
      .order("search_volume DESC")
      .limit(5)

    @keywords = keyword_data[:data]
    @total_keyword_pages = keyword_data[:total_pages]
    projects_data = paginate_projects(3)
    @projects = projects_data[:data]
    @total_pages = projects_data[:total_pages]
    @projectsInsights = paginate_project_insights[:data]
    @insights_test = Project.all
  end
end
