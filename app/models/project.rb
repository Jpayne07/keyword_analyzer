class Project < ApplicationRecord
  belongs_to :user
  has_many :keywords, dependent: :destroy
  has_many :ngrams, dependent: :destroy
  validates :name, presence: true
  validate :projects_count_within_limit, on: :create
  validate :projects_keyword_count_within_limit, on: :create
  accepts_nested_attributes_for :keywords, allow_destroy: true
  before_destroy :destroy_keywords_in_batches
  @project_limit=5

  def projects_count_within_limit
    if user.projects.reload.count >= 10
    errors.add(:base, "Exceeded projects limit")
    print errors.full_messages
    end
  end
  def projects_keyword_count_within_limit
    if keywords.count >= 1_000_000
      errors.add(:base, "Exceeded keywords limit")
    end
  end

def total_kw_count_within_limit
  # Get the total number of keywords across all the user's projects
  keyword_count = Keyword.where(project_id: user.project_ids).count

  if keyword_count >= 150000
    errors.add(:base, "Exceeded projects limit")
  end
end

  def destroy_keywords_in_batches
    keywords.in_batches(of: 1000) do |batch|
      batch.delete_all
      sleep(0.1)
    end
  end
end
