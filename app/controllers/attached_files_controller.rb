class AttachedFilesController < ApplicationController
  before_action :set_issue_and_attached_file

  # DELETE /attachments/{:file_id}
  def destroy
    if @attached_file
      @attached_file.destroy
    end

    logger.debug(params[:page].to_s)
    logger.debug("The URL" + request.path)
    if request.path == '/issues/' + @issue.id.to_s + '/edit'
      redirect_to "/issues/#{ @issue.id }/edit"
    else
      redirect_to "/issues/#{ @issue.id }"
    end
  end

  private

  def set_issue_and_attached_file
    @attached_file = AttachedFile.find_by(id: params[:id])
    @issue = Issue.find_by(id: @attached_file.issue_id)
  end
end
