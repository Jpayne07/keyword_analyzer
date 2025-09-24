# frozen_string_literal: true

class AddBrandToNgram < ActiveRecord::Migration[8.0]
  def change
    add_column :ngrams, :brand, :string
  end
end
