module KwToNgram
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
      Ngram.create(phrase: hash, weighted_frequency: data[:weighted_frequency], count: data[:count], project: @project)
    end
  end
end
