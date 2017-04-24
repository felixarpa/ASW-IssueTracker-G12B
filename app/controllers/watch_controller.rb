class WatchController < ApplicationController
  before_action :set_issue

  def index
    if @issue.watchers.exists?(@current_user.id)
      @issue.watchers.delete(@current_user)
    else
      @issue.watchers << @current_user
    end
    redirect_to "/issues/#{ @issue.id }"
  end

  private

  def set_issue
    @issue = Issue.find_by(id: params[:id])
  end
end
