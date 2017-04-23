class Issue < ApplicationRecord
  enum kind: [ :bug, :enhancement, :proposal, :task ]
  belongs_to :user
  has_many :assigned_users, :class_name => "User"
  has_and_belongs_to_many :votes, join_table: 'table_votes',
                          class_name: 'User'
end
