module PhraseParser
  extend ActiveSupport::Concern

  def kw_to_ngram
  kw_holder = Hash.new { |hash, key| hash[key] = { count: 0, weighted_frequency: 0 } }
  all_keywords = Keyword.where(project_id: @project.id)
  all_keywords.each do | keyword |
    kw_array = keyword.name.downcase.split(" ")
    n_count = [ 1, 2, 3, 4 ]
      n_count.each do |n|
        kw_array.each_cons(n) do |kw|
          key = kw.join(" ")
          kw_holder[key][:count] +=1
          kw_holder[key][:weighted_frequency] += keyword.search_volume
          end
      end
    end
    print kw_holder
    kw_holder.each do | hash, data |
      #   Turbo::StreamsChannel.broadcast_prepend_to(
      #   [ @project, :ngrams ], # becomes "project_5_ngrams"
      #   target: dom_id(@project, :ngrams),
      #   partial: "projects/ngram",
      #   locals: { ngram: hash }
      # )
      Ngram.create(phrase: hash, weighted_frequency: data[:weighted_frequency], count: data[:count], project: @project)
    end
  end

  def url_pattern
  # want to use this down the road
  # uri = URI.parse(url)
  # path_segments = uri.path.split("/")    # e.g. ["", "tools-electric", "saws"]
  # first_folder = path_segments[1]

  kw_holder = Hash.new { |hash, key| hash[key] = { count: 0 } }
  all_urls = Keyword.where(project_id: @project.id).pluck(:url).uniq
  categories_saved = []
  all_urls.each do | url |
    first_folder = url[/\.com\/([^\/]+)/, 1]

  next unless first_folder  # skip if there's no match
  url_phrase_array = first_folder
    .downcase
    .split(/[-.]/)
    .reject(&:empty?)
    url_hash = { url => [] }
    n_count = [ 1, 2, 3 ]
      n_count.each do |n|
        url_phrase_array.each_cons(n) do |kw|
          key = kw.join(" ")
          next if key.length < 3
          next if key.include?(" a ")
          next if key.include?("a ")
          next if key.include?(" a")
          next if key.include?("/")
          next if url_hash[url].include?(key)
          kw_holder[key][:count] +=1
          url_hash[url] << key
          end
      end
      categories_saved << url_hash
    end
      return_array = [ categories_saved, kw_holder.sort_by { |_, v| -v[:count] }.to_h.take(10) ]
      # print "url hash: #{url_hash}"
      return_array
    # print kw_holder.sort_by { |_, v| -v[:count] }.to_h.take(10)
  end
end
