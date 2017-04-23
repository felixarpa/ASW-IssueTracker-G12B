class Issue < ApplicationRecord
  enum kind: [ :bug, :enhancement, :proposal, :task ]
  belongs_to :user
  has_many :assigned_users, :class_name => "User"
end
