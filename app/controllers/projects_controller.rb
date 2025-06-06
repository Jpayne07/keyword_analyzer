class ProjectsController < ApplicationController
    include Paginatable

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
    @projects = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(product_params)
    if @project.save
      redirect_to @project
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def product_params
      params.expect(project: [ :name, :user_id ])
    end
end
