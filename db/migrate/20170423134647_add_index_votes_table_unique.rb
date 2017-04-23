class AddIndexVotesTableUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :table_votes, [ :issue_id, :user_id ], unique: true
  end
end
