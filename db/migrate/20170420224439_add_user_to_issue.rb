class AddUserToIssue < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :user_id, :integer
  end
end
