class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  include Paginatable
  include ProjectViewData


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

  def show
    project_id_url_table
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project
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
    end

  def set_project
    @project = Project.find(params[:id])
  end
end
