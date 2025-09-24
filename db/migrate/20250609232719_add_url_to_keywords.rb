# frozen_string_literal: true

class AddUrlToKeywords < ActiveRecord::Migration[8.0]
  def change
    add_column :keywords, :url, :string
  end
end
