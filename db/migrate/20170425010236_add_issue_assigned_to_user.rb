class AddIssueAssignedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :issue_id, :integer, index: true
  end
end
