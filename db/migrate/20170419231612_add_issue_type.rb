class AddIssueType < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :kind, :integer, default: 0
  end
end
