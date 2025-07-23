class Keyword < ApplicationRecord
  belongs_to :project
  before_validation :normalize_url
  validates :name, presence: true
  validates :search_volume, presence: true
  validates :url, presence: true
  require "csv"


  def self.search(query, project_id)
  scope = where(project_id: project_id)
  scope = scope.where("name LIKE ?", "%#{query}%") if query.present?
  scope
  end

  def self.search_insights(query, project_id)
  scope = where(project_id: project_id)
  scope = scope.where("url LIKE ?", "%#{query}%") if query.present?
  scope.group(:url)
  .select("url AS name, SUM(search_volume) AS search_volume, SUM(estimated_traffic) AS estimated_traffic, COUNT(name) AS kw_count")
  .order("search_volume DESC")
  .limit(50)
  end

  def normalize_url
    return unless url.present?

    self.url = url
      .delete_prefix("https://")
      .delete_prefix("http://")
      .delete_prefix("www.")
  end

    def self.to_csv(keyword)
    CSV.generate(headers: true) do |csv|
      csv << [ "Name", "URL", "Search Volume", "Estimated Traffic" ] # headers
      keyword.each do |k|
        csv << [ k.name, k.url, k.search_volume, k.estimated_traffic ]
      end
    end
    end
end
