class VoteController < ApplicationController
  before_action :set_issue

  # POST /issues/:issue_id/vote
  # POST /issues/:issue_id/vote.json
  def create
    if @issue and current_user

      message = 'Issue voted'
      if @issue.votes.exists?(current_user.id)
        @issue.votes.delete(current_user)
        message = 'Issue unvoted'
      else
        @issue.votes << current_user
      end
      respond_to do |format|
        format.html { redirect_to "/issues/#{ @issue.id }" }
        format.json { render json: { issue: @issue }
                                       .merge(message: message), status: :ok }
      end

    else

      respond_to do |format|
        if @issue.nil?
          format.json { render json: { error:
                                           { message: 'Issue does not exist' }
          }, status: :not_found }
        elsif current_user.nil?
          format.json { render json: { error:
                                           { message: 'Unauthorized' }
          }, status: :unauthorized }
        end
      end

    end
  end

  private

  def set_issue
    @issue = Issue.find_by(id: params[:id])
  end
end
