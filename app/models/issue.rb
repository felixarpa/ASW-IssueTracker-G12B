class Issue < ApplicationRecord
  enum kind: [ :bug, :enhancement, :proposal, :task ]
  enum priority: { trivial: 0, minor: 1, major: 2, critical: 3, blocker: 4 }
  enum status: { new_issue: 'New', open: 'Open', on_hold: 'On hold',
                 invalid_issue: 'Invalid', resolved: 'Resolved',
                 closed: 'Closed' }
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :assignee, optional: true, class_name: 'User', foreign_key: 'assignee_id'
  has_and_belongs_to_many :votes, join_table: 'table_votes', class_name: 'User'
  has_and_belongs_to_many :watchers, join_table: 'table_watchers', class_name: 'User'
  has_many :attached_files, dependent: :destroy

  # Comments
  has_many :comments
  has_many :users_commenting, through: :comments, source: :user

  validates :title, presence: true
  validates :kind, presence: true
  validates :priority, presence: true
  validate :check_assignee

  def check_assignee
    errors.add(:assignee_id, "Assignee doesn't exist") if !assignee_id.nil? && !User.exists?(id: assignee_id)
  end
end
