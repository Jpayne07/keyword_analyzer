class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all.limit(10)
  end
end
