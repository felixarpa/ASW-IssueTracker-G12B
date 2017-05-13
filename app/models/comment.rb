class Comment < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  def as_json(options = {})
    super(options.reverse_merge(except: [:user_id, :issue_id]))
        .merge(_links: {
            creator: self.user.as_json_summary
        })
  end
end
