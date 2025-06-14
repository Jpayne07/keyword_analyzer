class AddEstimatedTrafficToKeywords < ActiveRecord::Migration[8.0]
  def change
    add_column :keywords, :estimated_traffic, :integer
  end
end
