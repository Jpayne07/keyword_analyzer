class Project < ApplicationRecord
  belongs_to :user
  has_many :keywords, dependent: :destroy
  validate :projects_count_within_limit, on: :create

  @project_limit=5

  def projects_count_within_limit
    if user.projects.reload.count >= 5
    errors.add(:base, "Exceeded projects limit")
    print errors.full_messages
    end
  end
end
