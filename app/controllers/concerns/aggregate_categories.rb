module AggregateCategories
  extend ActiveSupport::Concern

  def aggregate_categories(selected_brand_categories, first_folder, category_volumes, kw)
    selected_brand_categories.each_value do |categories|
      categories.each do |cat|
        next unless first_folder.include?(cat.downcase)

        category_volumes[cat] += kw.search_volume.to_i
      end
    end
  end

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
