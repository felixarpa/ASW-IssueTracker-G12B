class AddAssigneeIdToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :assignee_id, :belongs_to
  end
end
