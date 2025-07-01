class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  include Paginatable
  include ProjectViewData
  include PhraseParser
  include ProjectsHelper
  include ExportToZip
  include ImportKeywords
  include LoadInSuggestions
  # include ExportProcessing
  require "csv"
  require "zip"


  def project_params
  params.require(:project).permit(
    :name,
    keywords_attributes: [ :id, :name, :search_volume, :url, :est_traffic, :keyword_category, :_destroy ]
  )
  end
  def index # all projects
    @current_page = current_page(3)
    @projects = Project.all.limit(20)
    @current_page_insights = current_page(6)
    @insights_per_page = 6
    @projectsInsights = paginate_project_insights[:data]
    @total_project_pages = paginate_project_insights[:total_pages]
  end
  def show # individual projects
    project_id_tables # concern which processes the data
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def export_zip_file
    @project = Project.find(params[:project_id])
    project_id_tables(100000, 100000, 10000)
    export_zip
  end
  def search
    session[:kw_query] = params[:query] # setting query for kw filtering
    project_id = params[:project_id] # pulling project id from beforeaction in project_view
    @keywords = Keyword.search(params[:query], project_id) # utilizing search method in kw model
    @table_config = project_id_kw_table # pulling from projects_helper
    # respond_to(&:turbo_stream)
  end

  def search_insights
    session[:url_query] = params[:query]
    project_id = params[:project_id]
    @url_list = Keyword.search_insights(params[:query], project_id)
    # respond_to(&:turbo_stream)
  end
  def search_ngram
    session[:ngram_query] = params[:query]
    project_id = params[:project_id]
    @phrases = Ngram
    .search(params[:query], project_id)
    .limit(100)
    .order("weighted_frequency DESC")
    # respond_to(&:turbo_stream)
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
        import_keywords_from_csv(@project, params[:project][:csv_file])
        @items = url_pattern[1] # from phrase_parser.rb
        # .order("count_DESC")
        # .limit(10)
        render turbo_stream: turbo_stream
        .update("modal",
        partial: "components/modals/category_selection_form",
        locals: { items: @items, key_holder: [] })
        kw_to_ngram
        return
      end
    respond_to do |format|
      format.html { redirect_to @project }
    end
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
  end
  def modal
    @project = Project.new
    @project.keywords.build
  end

 def category_select
  selected = params[:selected_categories] || []
  project_id = params[:project_id]

  return if selected.empty?

  # For each keyword, check if its URL includes any selected category string
  Keyword.where(project_id: project_id).find_each do |kw|
    matched_category = selected.find { |cat| kw.url.downcase.include?(cat.downcase) }

    if matched_category
      kw.update(keyword_category: matched_category)
    end
  end

  # redirect_to project_path(project_id), notice: "Categories applied to matching URLs"
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
end
