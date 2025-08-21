class AddBrandToKeywords < ActiveRecord::Migration[8.0]
  def change
    add_column :keywords, :brand, :string
  end
end
