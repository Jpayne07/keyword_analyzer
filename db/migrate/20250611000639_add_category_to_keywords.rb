# frozen_string_literal: true

class AddCategoryToKeywords < ActiveRecord::Migration[8.0]
  def change
    add_column :keywords, :keyword_category, :string
  end
end
