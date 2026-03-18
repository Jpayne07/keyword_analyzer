module AggregateCategories
  extend ActiveSupport::Concern

  def assign_categories(first_folder, sorted_volumes, keyword)
    first_folder_phrases = first_folder.split(' ')
    matched_category = sorted_volumes.keys.find do |key|
      first_folder_phrases.any? { |phrase| key.include?(phrase) }
    end
    keyword.keyword_category = if matched_category.nil? || matched_category.blank?
                                 '(Blank)'
                               else
                                 matched_category
                               end
  end
end
