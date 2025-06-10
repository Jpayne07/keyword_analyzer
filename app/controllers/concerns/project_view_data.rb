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
    @keywords = keyword_data[:data]
    @total_keyword_pages = keyword_data[:total_pages]
    projects_data = paginate_projects(3)
    @projects = projects_data[:data]
    @total_pages = projects_data[:total_pages]
    @projectsInsights = paginate_project_insights[:data]
    @insights_test = Project.all
  end
end
