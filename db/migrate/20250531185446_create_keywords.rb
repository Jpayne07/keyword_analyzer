# frozen_string_literal: true

class CreateKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :keywords do |t|
      t.string :keyword
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
