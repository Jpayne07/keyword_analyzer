class Ngram < ApplicationRecord
  belongs_to :project
  def self.search(query, project_id)
  scope = where(project_id: project_id)
  scope = scope.where("phrase LIKE ?", "%#{query}%") if query.present?
  scope
  end
end
