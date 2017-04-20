class Issue < ApplicationRecord
  enum kind: { bug: '/images/issue_types/bug.svg',
               enhancement: '/images/issue_types/enhancement.svg',
               proposal: '/images/issue_types/suggestion.svg',
               task: '/images/issue_types/task.svg' }
end
