class IssueSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :kind,
             :priority, :status, :votes

  def votes
    object.votes.size
  end

  def _embedded
    {
        comments: object.comments
    }
  end
end
