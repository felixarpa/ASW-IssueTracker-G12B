class IndexIssueSerializer < IssueSerializer
  attribute :voted_by_current_user, if: :current_user?
  attributes :_links

  def current_user?
    true if current_user
  end

  def voted_by_current_user
    object.votes.exists?(current_user.id)
  end

  def _links
    links = {
        self: { href: "/issues/#{object.id}.json" },
        creator: object.user.as_json_summary,
    }

    if object.assignee
      links = links.merge(
          assignee: object.assignee.as_json_summary)
    end

    links
  end
end