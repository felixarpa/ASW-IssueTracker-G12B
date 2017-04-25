class AddAssigneeIdToIssue < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :assignee_id, :integer
  end
end
