class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  include Paginatable
  include ProjectViewData
  include KwToNgram

  def index
    @current_page = current_page(3)
    @per_page = 3
    @projects = paginate_projects(3)[:data]
    @total_pages= paginate_projects(3)[:total_pages]

    @current_page_insights = current_page(6)
    @insights_per_page = 6
    @projectsInsights = paginate_project_insights[:data]
    @total_project_pages = paginate_project_insights[:total_pages]
  end
  def project_params
    params.require(:project).permit(
      :name,
      keywords_attributes: [ :id, :name, :search_volume, :url, :est_traffic, :keyword_category, :_destroy ]
    )
  end

  def show
    project_id_url_table
  end

  def new
    @project = Project.new
    @project.keywords.build
  end

def create
  @project = Project.new(project_params)
  @project.user = current_user

  if @project.save

    if params[:project][:csv_file].present?
      print "csv present"
      import_keywords_from_csv(@project, params[:project][:csv_file])
      # show logic for processing ngram here
      kw_to_ngram(2)
    end
    redirect_to @project, notice: "Project created with keywords."
  else
    render :new, status: :unprocessable_entity
  end
end
  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
      @project.destroy
      redirect_to projects_path
  end
  private
    def project_params
      params.expect(project: [ :name, :user_id ])
      params.require(:project).permit(:name)
    end

  def set_project
    @project = Project.find(params[:id])
  end
end

def import_keywords_from_csv(project, file)
  require "csv"
  content = file.read.force_encoding("UTF-8")
  content = content.sub("\xEF\xBB\xBF", "").gsub("\r", "").strip
  csv = CSV.parse(content, headers: true)
  csv.each do |row|
    row = row.to_h.transform_keys(&:strip)
    project.keywords.create!(
      name: row["keyword"],
      search_volume: row["search_volume"],
      url: row["url"],
      estimated_traffic: row["est_traffic"],
      keyword_category: row["keyword_category"]
    )
  end
end
