# app/models/insight.rb
class Insight
  attr_reader :keyword_count, :ngram_count, :categories

  def initialize(user)
    @keyword_count = Project.where(user: user).sum { |p| p.keywords.count }
    @ngram_count = Project.where(user: user).sum { |p| p.ngrams.count }
    @categories = Keyword
      .joins(:project)
      .where(projects: { user_id: user.id })
      .select(:keyword_category)
      .distinct
  end
end
