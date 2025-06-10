class AddUserIdToProjectIssues < ActiveRecord::Migration[8.0]
  def change
    add_column :project_issues, :user_id, :integer
  end
end
