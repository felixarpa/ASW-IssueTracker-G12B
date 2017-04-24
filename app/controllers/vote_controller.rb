class VoteController < ApplicationController
  before_action :set_issue

  def index
    if @issue.votes.exists?(current_user.id)
      @issue.votes.delete(current_user)
    else
      @issue.votes << current_user
    end
    redirect_to "/issues/#{ @issue.id }"
  end

  private

  def set_issue
    @issue = Issue.find_by(id: params[:id])
  end
end
