class WatchController < ApplicationController
  before_action :set_issue

  def toggle
    if @issue.status == 0
      @issue.status = 1
    else
      @issue.status = 0
    end
    redirect_to "/issues/#{ @issue.id }"
  end
end
