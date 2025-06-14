class Project < ApplicationRecord
  belongs_to :user
  has_many :keywords, dependent: :destroy
  has_many :ngrams, dependent: :destroy
  validate :projects_count_within_limit, on: :create
  accepts_nested_attributes_for :keywords, allow_destroy: true
  @project_limit=5

  def projects_count_within_limit
    if user.projects.reload.count >= 100
    errors.add(:base, "Exceeded projects limit")
    print errors.full_messages
    end
  end
end
