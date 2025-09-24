# frozen_string_literal: true

class FixKeywordName < ActiveRecord::Migration[8.0]
  def change
    rename_column :keywords, :keyword, :name
  end
end
