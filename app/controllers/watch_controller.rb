class WatchController < ApplicationController
  before_action :set_issue

  # POST /issues/:issue_id/watch
  # POST /issues/:issue_id/watch.json
  def create
    if @issue.watchers.exists?(current_user.id)
      @issue.watchers.delete(current_user)
      message = 'Unwatched issue'
    else
      @issue.watchers << current_user
      message = 'Watched issue'
    end
    respond_to do |format|
      format.html { redirect_to "/issues/#{ @issue.id }" }
      format.json { render json: { message: message }, status: :ok }
    end
  end

  private

  def set_issue
    @issue = Issue.find_by(id: params[:id])
    render json: { message: 'Issue not found' }, status: :not_found if @issue.nil?
  end
end
