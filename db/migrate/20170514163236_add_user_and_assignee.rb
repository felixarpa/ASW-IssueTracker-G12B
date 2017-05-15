class AddUserAndAssignee < ActiveRecord::Migration[5.0]
  def change
    add_reference :issues, :user, foreign_key: false
    add_reference :issues, :assignee, foreign_key: false
  end
end
