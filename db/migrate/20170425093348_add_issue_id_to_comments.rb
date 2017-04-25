class AddIssueIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :issue_id, :integer
  end
end
