class AddUserAndAssignee < ActiveRecord::Migration[5.0]
  def change
    add_reference :issues, :user, foreign_key: true
    add_reference :issues, :assignee, foreign_key: true
  end
end
