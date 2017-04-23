class CreateTableVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :table_votes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :issue, index: true
    end
  end
end
