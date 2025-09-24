# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :project
  before_validation :normalize_url, :normalize_category
  validates :name, presence: true, length: { maximum: 50 }
  validates :search_volume, presence: true
  validates :url, presence: true
  validates :brand, presence: true
  validate :projects_keyword_count_within_limit, on: :create
  validate :total_kw_count_within_limit, on: :create
  has_one :user, through: :project

  require 'csv'

  MAX_KEYWORDS_PER_USER = 150_000
  MAX_KEYWORDS_PER_PROJECT = 100_000
  def self.search(query, project_id)
    scope = where(project_id: project_id)
    scope = scope.where('name LIKE ?', "%#{query}%") if query.present?
    scope
  end

  def self.search_insights(query, project_id)
    scope = where(project_id: project_id)
    scope = scope.where('url LIKE ?', "%#{query}%") if query.present?
    scope.group(:url)
         .select('url AS name, SUM(search_volume) AS search_volume, SUM(estimated_traffic) AS estimated_traffic, COUNT(name) AS kw_count')
         .order('search_volume DESC')
         .limit(50)
  end

  def projects_keyword_count_within_limit
    return unless project.keywords.count >= MAX_KEYWORDS_PER_PROJECT

    errors.add(:base, 'Exceeded keywords limit')
  end

  def total_kw_count_within_limit
    # Get the total number of keywords across all the user's projects
    keyword_count = Keyword.where(project_id: user.project_ids).count
    return unless keyword_count >= MAX_KEYWORDS_PER_USER

    errors.add(:base, 'Exceeded projects limit')
  end

  def normalize_url
    return if url.blank?

    self.url = url
               .delete_prefix('https://')
               .delete_prefix('http://')
               .delete_prefix('www.')
  end

  def self.to_csv(keyword)
    CSV.generate(headers: true) do |csv|
      csv << ['Name', 'URL', 'Search Volume', 'Estimated Traffic', 'Brand'] # headers
      keyword.each do |k|
        csv << [k.name, k.url, k.search_volume, k.estimated_traffic, k.brand]
      end
    end
  end

  private

  def normalize_category
    self.keyword_category = '(Blank)' if keyword_category.nil?
  end
end
