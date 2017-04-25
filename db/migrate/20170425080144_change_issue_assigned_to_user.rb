class ChangeIssueAssignedToUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :issue_id, :integer, index: true
  end
end
