class AddIndexWatchersTableUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :table_watchers, [ :issue_id, :user_id ], unique: true
  end
end
