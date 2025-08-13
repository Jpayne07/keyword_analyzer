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
  require "benchmark"
  require "activerecord-import"


  def project_params
  params.require(:project).permit(
    :name,
    keywords_attributes: [ :id, :name, :search_volume, :url, :est_traffic, :keyword_category, :_destroy ]
  )
  end
  def index # all projects
    @current_page = current_page(3)
    @projects = Project
        .where(user: current_user)
    @current_page_insights = current_page(6)
    @insights_per_page = 6
    @projectsInsights = paginate_project_insights[:data]
    @total_project_pages = paginate_project_insights[:total_pages]
    @insights = Insight.new(current_user)
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

  def search_categories
  session[:category_query] = params[:query]
  project_id = params[:project_id]
  @categories = @top_categories
    .where(project_id: project_id)
      .search(params[:query], project_id)
  .limit(10)
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
        @items = url_pattern
        render turbo_stream: turbo_stream
        .update("modal",
        partial: "components/modals/category_selection_form",
        locals: { items: @items, key_holder: [] })
        if params[:accept_ngram].present?
              kw_to_ngram
        end
        return
      end



    respond_to do |format|
      format.html { redirect_to @project }
    end
    else
      render :new, status: :unprocessable_entity
    end
  end

def categories
  @project = Project.find(params[:project_id])
  @items = url_pattern # same method you used in create
  key_holder = []
  @items.each { |key, _value| key_holder << key }

  render partial: "components/modals/categories",
         locals: { key_holder: key_holder, brand: params[:brand] },
         layout: false
end
  def edit
  end
  def modal
    @project = Project.new
    @project.keywords.build
  end

def category_select
  selected = params[:selected_categories] || {}
  project_id = params[:project_id]
  @project = Project.find(project_id)

  return if selected.blank?

  category_volumes = Keyword
    .where(project_id: project_id)
    .group(:keyword_category)
    .sum(:search_volume)

  updated_keywords = []

  Keyword.where(project_id: project_id).find_in_batches(batch_size: 500) do |batch|
    batch.each do |kw|
      clean_url = kw.url.to_s.downcase
      first_folder = clean_url[%r{\.\w+\/([^\/]+)}, 1]&.tr("-", " ")

      next if first_folder.nil?

      selected.each do |_brand, categories|
        categories.each do |cat|
          next unless first_folder.include?(cat.downcase)

          best_category = categories.max_by { |c| category_volumes[c] || 0 }
          next if best_category.nil? || kw.keyword_category == best_category

          kw.keyword_category = best_category
          updated_keywords << kw
        end
      end
    end

    if updated_keywords.any?
      Keyword.import(
        updated_keywords,
        on_duplicate_key_update: {
          conflict_target: [ :id ],
          columns: [ :keyword_category ]
        }
      )
      updated_keywords.clear
    end
  end

  redirect_to project_path(project_id), notice: "Categories applied to matching URLs"
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

    def set_project
    @project = current_user.projects.find(params[:id])
    puts "setting project! #{@project}"
    end
end
