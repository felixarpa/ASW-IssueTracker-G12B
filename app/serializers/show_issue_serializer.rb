class ShowIssueSerializer < IssueSerializer
  attributes :watchers
  attribute :voted_by_current_user, if: :current_user?
  attribute :watched_by_current_user, if: :current_user?

  attributes  :_links, :_embedded

  def current_user?
    true if current_user
  end

  def watchers
    object.watchers.size
  end

  def voted_by_current_user
    object.votes.exists?(current_user.id)
  end

  def watched_by_current_user
    object.watchers.exists?(current_user.id)
  end

  def _links
    links = {
        creator: object.user.as_json_summary,
    }

    if object.assignee
      links = links.merge(
          assignee: object.assignee.as_json_summary)
    end

    if current_user
      links = links.merge(
          vote: { href: "/issues/#{object.id}/vote" },
          watch: { href: "/issues/#{object.id}/watch" }
      )
    end

    links
  end
end
