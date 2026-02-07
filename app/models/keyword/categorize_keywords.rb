class Keyword::Categorize_Keywords
  def initialize(keyword, selected, updated_keywords)
    @keyword = keyword
    @selected = selected
    @keyword_holder = updated_keywords
  end

  def self.extract_first_folder(url)
    return nil if url.blank?

    clean_url = url.to_s.downcase
    clean_url[%r{\.\w+/([^\/]+)}, 1]&.tr('-', ' ')
  end

  def update_keywords(keyword_holder)
    keyword_holder << @keyword
  end

  def self.find_first_category(categories, first_folder)
    categories.each do |cat|
      if first_folder.include?(cat.downcase)
        break if @keyword.keyword_category == cat

        @keyword.keyword_category = cat
      else
        @keyword.keyword_category = '(blank)'
      end
      break if @keyword.keyword_category != '(blank)'
    end
    update_keywords(@keyword_holder)
  end

  def self.match_selected_with_url(updated_keywords, first_folder)
    @selected.each do |brand, categories|
      next unless brand == @keyword.brand

      find_first_category(categories, updated_keywords, first_folder)
    end
  end
end
