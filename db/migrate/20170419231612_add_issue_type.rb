class AddIssueType < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :kind, :string, default: '/images/issue_types/task.svg'
  end
end
