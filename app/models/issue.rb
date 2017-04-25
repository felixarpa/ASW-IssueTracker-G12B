class Issue < ApplicationRecord
  enum kind: [ :bug, :enhancement, :proposal, :task ]
  enum priority: { trivial: 0, minor: 1, major: 2, critical: 3, blocker: 4 }
  enum status: { new_issue: 'New', open: 'Open', on_hold: 'On hold',
                 invalid_issue: 'Invalid', resolved: 'Resolved',
                 closed: 'Closed' }
  belongs_to :user
  has_one :assignee, class_name: 'User'
  has_and_belongs_to_many :votes, join_table: 'table_votes', class_name: 'User'
  has_and_belongs_to_many :watchers, join_table: 'table_watchers', class_name: 'User'
  has_many :attached_files, :dependent => :destroy

  validates :kind, presence: true
  validates :title, presence: true
  validates :priority, presence: true

  attr_reader :assignee
end
