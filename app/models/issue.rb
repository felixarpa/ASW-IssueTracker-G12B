class Issue < ApplicationRecord
  enum kind: { bug: '/images/issue_types/bug.svg',
               enhancement: '/images/issue_types/enhancement.svg',
               proposal: '/images/issue_types/suggestion.svg',
               task: '/images/issue_types/task.svg' }
    belongs_to :user
    has_many :assigned_users, :class_name => "User"
end
