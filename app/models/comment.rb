class Comment < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  validates :body, presence: true

  def as_json(options = {})
    super(options.reverse_merge(except: [:id, :user_id, :issue_id]))
        .merge(_links: {
            self: { href: "/issues/#{self.issue.id}/comments/#{self.id}" },
            creator: self.user.as_json_summary
        })
  end
end
