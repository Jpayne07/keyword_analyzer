# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :keywords, dependent: :destroy
  has_many :ngrams, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validate :projects_count_within_limit, on: :create
  accepts_nested_attributes_for :keywords, allow_destroy: true
  before_destroy :destroy_keywords_in_batches
  PROJECT_LIMIT = 5

  def projects_count_within_limit
    return unless user.projects.reload.count >= PROJECT_LIMIT

    errors.add(:base, 'Exceeded projects limit')
    Rails.logger.debug errors.full_messages
  end

  def destroy_keywords_in_batches
    keywords.in_batches(of: 1000) do |batch|
      batch.delete_all
      sleep(0.1)
    end
  end
end
