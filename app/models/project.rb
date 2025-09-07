class Project < ApplicationRecord
  belongs_to :user
  has_many :keywords, dependent: :destroy
  has_many :ngrams, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validate :projects_count_within_limit, on: :create
  accepts_nested_attributes_for :keywords, allow_destroy: true
  before_destroy :destroy_keywords_in_batches
  @project_limit=5

  def projects_count_within_limit
    if user.projects.reload.count >= 100
    errors.add(:base, "Exceeded projects limit")
    print errors.full_messages
    end
  end

  def destroy_keywords_in_batches
    keywords.in_batches(of: 1000) do |batch|
      batch.delete_all
      sleep(0.1)
    end
  end
end
