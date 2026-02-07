# frozen_string_literal: true

module ImportKeywords
  extend ActiveSupport::Concern
  require 'activerecord-import'
  class BadHeaders < StandardError
    attr_reader :error_code, :user_message

    def initialize(msg = 'Headers are not set', error_code = 422, user_message = nil)
      @error_code = error_code
      @user_message = user_message
      super(msg)
    end
  end

  class UploadLimit < StandardError
    attr_reader :error_code, :user_message

    def initialize(msg = 'Upload file is too large', error_code = 422, user_message = nil)
      @error_code = error_code
      @user_message = user_message
      super(msg)
    end
  end

  def import_keywords_from_csv(project, file)
    require 'csv'
    content = file.read.force_encoding('UTF-8')
    content = content.sub("\xEF\xBB\xBF", '').gsub("\r", '').strip
    row_count = CSV.parse(content, headers: true).size
    file.rewind
    # comes from the keyword model and the defined limit within
    if @project.keywords.count + row_count > Keyword::MAX_KEYWORDS_PER_PROJECT
      raise UploadLimit,
            'File is too large. Expected less than 100k rows'
    end
    if Keyword.where(project_id: @project.user.project_ids).count + row_count > Keyword::MAX_KEYWORDS_PER_USER
      raise UploadLimit,
            'File is too large. Expected less than 150k rows'
    end

    normalizer = proc do |field|
      case field.downcase
        # normalizing based on what headers a user enters
      when 'volume', 'search volume'
        'search_volume'
      else
        field.downcase
      end
    end
    keywords = []
    csv = CSV.parse(content, headers: true, header_converters: normalizer)
    file.rewind
    expected_headers = %w[keyword search_volume brand url est_traffic]
    normalized_csv_headers = csv.headers.map { |h| h.to_s.encode('UTF-8').strip.downcase.sub(/\A\uFEFF/, '') }.uniq
    normalized_expected    = expected_headers.map { |h| h.to_s.encode('UTF-8').strip.downcase }
    unless normalized_csv_headers.sort == normalized_expected.sort
      raise BadHeaders, "CSV headers mismatch. Expected: #{expected_headers.join(', ')}"
    end

    csv.each_slice(500) do |rows|
      sleep(0.1)
      keywords = rows.map do |row|
        row = row.to_h.transform_keys(&:strip)
        Keyword.new(
          url: row['url'],
          name: row['keyword'],
          search_volume: row['search_volume'],
          estimated_traffic: row['est_traffic'],
          keyword_category: row['keyword_category'],
          project_id: project.id,
          brand: row['brand']
        )
      end
      Keyword.import(keywords, validate: true)
    end
  end
end
