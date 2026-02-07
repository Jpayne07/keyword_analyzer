# frozen_string_literal: true

class PagesController < ApplicationController
  include Paginatable

  def home
    @keywords = Keyword.joins(:project).where(projects: { user_id: current_user.id }).limit(100)
    @kw_table_styling = 'home_kw_table'
    @projects_table_styling = 'home_projects_table'
    @current_page = current_page(10)
    @projects = Project.where(user: current_user)
    @total_pages = paginate_projects(3)[:total_pages]
    @projectsInsights = paginate_project_insights[:data]
    @total_project_pages = paginate_project_insights[:total_pages]
    @keyword_count = Project.where(user: current_user)
                            .sum { |project| project.keywords.count }
    @ngram_count = Project.where(user: current_user)
                          .sum { |project| project.ngrams.count }
    @keywords_limited = keyword_category_chart_data
  end

  def keyword_category_chart_data
    counts = Keyword.group(:keyword_category).order('count_all DESC').count

    # Split top 10 and the rest
    top_10 = counts.first(10).to_h
    other_total = counts.drop(10).sum { |_, v| v }

    # Add "Other" if there are more than 10
    top_10['Other'] = other_total if other_total.positive?
    top_10
  end
end
