module ImportKeywords
  extend ActiveSupport::Concern
    def import_keywords_from_csv(project, file)
    require "csv"
    content = file.read.force_encoding("UTF-8")
    content = content.sub("\xEF\xBB\xBF", "").gsub("\r", "").strip
    csv = CSV.parse(content, headers: true)
    csv.each do |row|
      row = row.to_h.transform_keys(&:strip)
      project.keywords.create!(
        name: row["keyword"],
        search_volume: row["search_volume"],
        url: row["url"],
        estimated_traffic: row["est_traffic"],
        keyword_category: row["keyword_category"]
      )
    end
    end
end
