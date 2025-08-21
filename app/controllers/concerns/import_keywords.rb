module ImportKeywords
  extend ActiveSupport::Concern
  require "activerecord-import"

  def import_keywords_from_csv(project, file)
    require "csv"
    content = file.read.force_encoding("UTF-8")
    content = content.sub("\xEF\xBB\xBF", "").gsub("\r", "").strip
    row_count = CSV.parse(content, headers: true).size
      # Reset pointer so we can re-read later
      file.rewind
      # Check project keyword limit (100k total for that project)
      if @project.keywords.count + row_count > 1_000_000
        @project.errors.add(:base, "This upload would exceed the 100,000 keyword limit for a single project.")
        return render :new, status: :unprocessable_entity
      end
    normalizer = proc do |field|
      case field.downcase
      when "volume", "search volume"
        "search_volume"
      when "name"
        "client_name"
      else
        field.downcase
      end
    end
    keywords = []

    csv = CSV.parse(content, headers: true, header_converters: normalizer)
    csv.each_slice(500) do |rows|
      sleep(0.1)
      keywords = rows.map do |row|
        row = row.to_h.transform_keys(&:strip)
        Keyword.new(
          url: row["url"],
          name: row["keyword"],
          search_volume: row["search_volume"],
          estimated_traffic: row["est_traffic"],
          keyword_category: row["keyword_category"],
          project_id: project.id,
          brand: row["brand"],
        )
      end

      Keyword.import(keywords, validate: true)
    end
  end
end
