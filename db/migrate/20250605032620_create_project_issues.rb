class CreateProjectIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :project_issues do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end
