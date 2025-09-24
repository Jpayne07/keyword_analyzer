# frozen_string_literal: true

module LoadInSuggestions
  extend ActiveSupport::Concern

  def load_items
    @items = Ngram.where(project_id: params[:project_id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: @items.map.with_index do |item, _idx|
          turbo_stream.append('modal', partial: 'component/modals/category_suggestions', locals: { item: item })
        end
      end
    end
  end
end
