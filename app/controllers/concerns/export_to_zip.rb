module ExportToZip
  extend ActiveSupport::Concern

  def generate_csv(records, headers)
    CSV.generate do |csv|
      csv << headers
      records.each { |record| csv << yield(record) }
    end
  end
  def export_zip
    kw_query = session[:kw_query]
    filter_urls = session[:url_query]
    filter_ngram = session[:ngram_query]
    project_id = params[:project_id]
    keywords = Keyword.search(kw_query, project_id)
    top_urls  = Keyword.search_insights(filter_urls, project_id)
    ngrams_for_export = Ngram.search(filter_ngram, project_id)
    top_categories = Keyword
      .where(project_id: @project.id)
      .group(:keyword_category)
      .select("keyword_category AS name,
              SUM(Search_Volume) AS search_volume,
              SUM(estimated_traffic) AS estimated_traffic,
              COUNT(name) AS kw_count")
      .order("search_volume DESC")
      .limit(5)

      temp_file = Tempfile.new([ "keyword_export", ".zip" ])

      Zip::OutputStream.open(temp_file.path) do |zip|
        zip.put_next_entry("All Up.csv")
        zip.write generate_csv(keywords, [ "ID", "Project ID", "Keyword", "Search Volume", "URL", "Category", "Brand" ]) { |k| [ k.id, k.project_id, k.name, k.search_volume,  k.url, k.keyword_category, k.brand ] }

        zip.put_next_entry("ngrams.csv")
        zip.write generate_csv(ngrams_for_export, [ "Phrase", "Frequency", "Brand" ]) { |ng| [ ng[:phrase], ng[:count], ng[:brand] ] }

        zip.put_next_entry("keywords.csv")
        zip.write generate_csv(keywords, [ "ID", "Name", "Project ID" ]) { |k| [ k.id, k.name, k.project_id ] }

        zip.put_next_entry("urls.csv")
        zip.write generate_csv(top_urls, [ "ID", "URL", "KW Count" ]) { |u| [ u.id, u.name, u[:kw_count] ] }

        zip.put_next_entry("categories.csv")
        zip.write generate_csv(top_categories, [ "ID", "Name" ]) { |c| [ c.id, c.name ] }
      end

      send_data File.read(temp_file.path),
                type: "application/zip",
                filename: "keywords_export.zip"
    ensure
      temp_file.close
      temp_file.unlink
  end
end
