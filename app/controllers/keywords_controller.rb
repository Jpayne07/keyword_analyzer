# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.limit(10)
  end

  def create
    @keyword = Keyword.new(keyword_params)
    if @keyword.save
      redirect_to @keyword.project, notice: 'Keyword created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end
end
