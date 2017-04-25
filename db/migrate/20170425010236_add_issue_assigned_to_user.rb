class AddIssueAssignedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :issue_id, :belongs_to, index: true
  end
end
