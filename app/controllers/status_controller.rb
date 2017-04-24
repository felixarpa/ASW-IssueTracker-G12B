class WatchController < ApplicationController
  before_action :set_issue

  # GET /status
  def show
    if @issue.status == 0
      @issue.status = 1
    else
      @issue.status = 0
    end
    redirect_to "/issues/#{ @issue.id }"
  end

  private

  def set_issue
    @issue = Issue.find_by(id: params[:id])
  end
end
