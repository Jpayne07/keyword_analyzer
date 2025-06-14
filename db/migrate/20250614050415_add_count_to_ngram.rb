class AddCountToNgram < ActiveRecord::Migration[8.0]
  def change
    add_column :ngrams, :count, :integer
  end
end
