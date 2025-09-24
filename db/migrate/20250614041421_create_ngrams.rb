# frozen_string_literal: true

class CreateNgrams < ActiveRecord::Migration[8.0]
  def change
    create_table :ngrams do |t|
      t.string :phrase
      t.references :project, null: false, foreign_key: true
      t.integer :weighted_frequency

      t.timestamps
    end
  end
end
