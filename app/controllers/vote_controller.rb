class VoteController < ApplicationController
  before_action :set_issue

  # POST /issues/:issue_id/vote
  # POST /issues/:issue_id/vote.json
  def create
    if @issue.votes.exists?(current_user.id)
      @issue.votes.delete(current_user)
      message = 'Issue unvoted'
    else
      @issue.votes << current_user
      message = 'Issue voted'
    end
    respond_to do |format|
      format.html { redirect_to "/issues/#{ @issue.id }" }
      format.json { render json: { message: message }, status: :ok }
    end
  end

  private

  def set_issue
    @issue = Issue.find_by(id: params[:id])
    render json: { error: 'Issue not found' }, status: :not_found if @issue.nil?
  end
end
