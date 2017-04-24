class AddIssueStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :status, :string, default: 'New'
  end
end
