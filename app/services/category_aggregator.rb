class CategoryAggregator
  def initialize(project_id:, selected:)
    @scope = Keyword.where(project_id: project_id)
    @selected = selected
    @category_volumes = Hash.new(0)
  end

  def call
    BatchingService.call(@scope) do |batch|
      process_batch(batch)
    end

    @category_volumes
  end

  private

  def process_batch(batch)
    batch.each do |kw|
      first_folder = extract_folder(kw.url)
      next if first_folder.nil?

      aggregate_categories(@selected, first_folder, @category_volumes, kw)
    end
  end

  def extract_folder(url)
    clean_url = url.to_s.downcase
    clean_url[%r{\.\w+/([^/]+)}, 1]&.tr('-', ' ')
  end

  def aggregate_categories(selected_brand_categories, first_folder, category_volumes, kw)
    selected_brand_categories.each_value do |categories|
      categories.each do |cat|
        next unless first_folder.include?(cat.downcase)

        category_volumes[cat] += kw.search_volume.to_i
      end
    end
  end
end
