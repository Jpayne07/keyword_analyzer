# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :log_params
  before_action :set_project, only: %i[show edit update destroy]
  include Paginatable
  include ProjectViewData
  include PhraseParser
  include ProjectsHelper
  include ExportToZip
  include ImportKeywords
  include LoadInSuggestions
  # include ExportProcessing
  require 'csv'
  require 'zip'
  require 'benchmark'
  require 'activerecord-import'
  def log_params
    Rails.logger.debug { ">>> #{controller_name}##{action_name} params: #{params.to_unsafe_h}" }
  end

  def project_params
    params.expect(
      project: [:name,
                { keywords_attributes: %i[id name search_volume url est_traffic keyword_category _destroy] }]
    )
  end

  # all projects
  def index
    @current_page = current_page(3)
    @projects = Project
                .where(user: current_user)
    @current_page_insights = current_page(6)
    @insights_per_page = 6
    @projectsInsights = paginate_project_insights[:data]
    @total_project_pages = paginate_project_insights[:total_pages]
    @insights = Insight.new(current_user)
  end

  # individual projects
  def show
    project_id_tables # concern which processes the data
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def export_zip_file
    @project = Project.find(params[:project_id])
    project_id_tables(100_000, 100_000, 10_000)
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
               .order('weighted_frequency DESC')
    # respond_to(&:turbo_stream)
  end

  def new
    @project = Project.new
    @project.keywords.build
  end

  def edit; end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      if params[:project][:csv_file].present?
        begin
          import_keywords_from_csv(@project, params[:project][:csv_file])
        rescue BadHeaders => e
          @project.delete
          @project.errors.add(:base, e.message)
          render :new, status: :unprocessable_entity and return
        rescue UploadLimit => e
          @project.delete
          @project.errors.add(:base, e.message)
          render :new, status: :unprocessable_entity and return
        end
        key_holder = []
        url_pattern.each do |key|
          key_holder << key
        end
        render turbo_stream: turbo_stream
          .update('modal',
                  partial: 'components/modals/category_selection_form',
                  locals: { key_holder: key_holder })
        kw_to_ngram if params[:accept_ngram].present?
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
    @items = url_pattern
    key_holder = []
    @items.each { |key| key_holder << key }

    render partial: 'components/modals/categories',
           locals: { key_holder: key_holder, brand: params[:brand] },
           layout: false
  end

  def modal
    @project = Project.new
    @project.keywords.build
  end

  def category_select
    selected = params[:selected_categories] || {}
    project_id = params[:project_id]
    @project = Project.find(project_id)

    if selected.blank?
      redirect_to project_path(project_id), notice: 'No categories have been selected.'
      return
    end

    category_volumes = Keyword
                       .where(project_id: project_id)
                       .group(:keyword_category)
                       .sum(:search_volume)

    Keyword.push_categories_into_keywords(project_id, selected)
    # Keyword.where(project_id: project_id).find_in_batches(batch_size: 500) do |batch|
    #    sleep(0.1)
    #    batch.each do |kw|
    #      clean_url = kw.url.to_s.downcase
    #      first_folder = clean_url[%r{\.\w+/([^\/]+)}, 1]&.tr('-', ' ')
    #
    #      next if first_folder.nil?
    #
    #      selected.each do |brand, categories|
    #        next unless brand == kw.brand
    #
    #        categories.each do |cat|
    #          if first_folder.include?(cat.downcase)
    #            break if kw.keyword_category == cat
    #
    #            kw.keyword_category = cat
    #          else
    #            kw.keyword_category = '(blank)'
    #          end
    #          updated_keywords << kw
    #          break if kw.keyword_category != '(blank)'
    #        end
    #      end
    #    end
    #
    #    if updated_keywords.any?
    #      Keyword.import(
    #        updated_keywords,
    #        on_duplicate_key_update: {
    #          conflict_target: [:id],
    #          columns: [:keyword_category]
    #        }
    #      )
    #      updated_keywords.clear
    #    end
    #  end

    redirect_to project_path(project_id), notice: 'Categories applied to matching URLs'
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.keywords.in_batches(of: 1000) do |batch|
      batch.delete_all
      sleep(0.1)
    end
    @project.destroy
    redirect_to projects_path
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
    Rails.logger.debug { "setting project! #{@project}" }
  end
end
