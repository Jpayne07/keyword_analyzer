# frozen_string_literal: true

module PhraseParser
  extend ActiveSupport::Concern

  def kw_to_ngram
    brand_ngram_map = Hash.new do |hash, brand|
      hash[brand] = Hash.new { |h, key| h[key] = { count: 0, weighted_frequency: 0 } }
    end
    all_keywords = Keyword.where(project_id: @project.id)
    all_keywords.each do |keyword|
      brand = keyword.brand&.downcase&.strip.presence || 'unbranded'
      kw_array = keyword.name.downcase.split
      n_count = [1, 2, 3, 4]
      n_count.each do |n|
        kw_array.each_cons(n) do |kw|
          key = kw.join(' ')
          holder = brand_ngram_map[brand]
          holder[key][:count] += 1
          holder[key][:weighted_frequency] += keyword.search_volume
        end
      end
    end
    brand_ngram_map.each do |brand, kw_holder|
      sorted = kw_holder.sort_by do |_, stats|
        if stats[:weighted_frequency].zero?
          [-1, -stats[:count]] # make it rank lower than any positive weight
        else
          [-stats[:weighted_frequency], 0]
        end
      end

      cutoff = (sorted.size * 0.1).ceil
      top_10_percent = sorted.first(cutoff)
      top_10_percent.each_slice(500) do |chunk|
        records = chunk.map do |phrase, stats|
          Ngram.new(
            phrase: phrase,
            count: stats[:count],
            weighted_frequency: stats[:weighted_frequency],
            project: @project,
            brand: brand
          )
        end
        # Import 500 at a time
        Ngram.import(records, validate: false)
      end
    end
  end

  def url_pattern
    brands = Keyword.where(project_id: @project.id).pluck(:brand).uniq
    brand_category = []
    brands.each do |brand|
      kw_holder = Hash.new { |hash, key| hash[key] = { count: 0 } }
      all_urls = Keyword.where(brand: brand).pluck(:url).uniq

      all_urls.each do |url|
        first_folder = url[%r{\.com/([^/]+)}, 1]
        next unless first_folder

        url_phrase_array = first_folder
                           .downcase
                           .split(/[-.]/)
                           .reject(&:empty?)
                           .reject { |t| t == 'a' } # filter 'a' up front

        seen_keys = []

        [1, 2, 3].each do |n|
          url_phrase_array.each_cons(n) do |kw|
            key = kw.join(' ')
            next if key.length < 3
            next if seen_keys.include?(key)

            seen_keys << key
            kw_holder[key][:count] += 1
          end
        end
      end

      top_50 = kw_holder.sort_by { |_, v| -v[:count] }.first(50).to_h
      brand_category << { brand => top_50 }
    end
    brand_category
  end
end
