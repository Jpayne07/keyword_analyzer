class AddSearchVolumeToKeywords < ActiveRecord::Migration[8.0]
  def change
    add_column :keywords, :search_volume, :integer
  end
end
