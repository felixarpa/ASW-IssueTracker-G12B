class Issue < ApplicationRecord
  enum kind: [ :bug, :enhancement, :proposal, :task ]
  enum priority: { trivial: 0, minor: 1, major: 2, critical: 3, blocker: 4 }
  belongs_to :user
  has_many :assigned_users, :class_name => "User"
  has_and_belongs_to_many :votes, join_table: 'table_votes', class_name: 'User'
  has_and_belongs_to_many :watchers, join_table: 'table_watchers', class_name: 'User'
  has_many :attached_files, :dependent => :destroy

  # validates :kind, presence: true
  validates :title, presence: true
  # validates :priority, presence: true
end
