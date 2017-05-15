class IssueSerializer < ActiveModel::Serializer
  attributes :title, :description, :created_at, :updated_at, :kind,
             :priority, :status, :votes

  def votes
    object.votes.size
  end

  def _embedded
    {
        comments: object.comments,
        attached_files: object.attached_files
    }
  end
end
