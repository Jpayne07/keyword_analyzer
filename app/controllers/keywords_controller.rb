class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all.limit(10)
  end
  def create
  @keyword = Keyword.new(keyword_params)
    if @keyword.save
      redirect_to @keyword.project, notice: "Keyword created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

private

def keyword_params
  params.require(:keyword).permit(:name, :search_volume, :url, :keyword_category, :project_id)
end
end
