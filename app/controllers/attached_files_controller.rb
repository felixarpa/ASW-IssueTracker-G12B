class AttachedFilesController < ApplicationController
  before_action :set_issue_and_attached_file

  # DELETE /attached_files/{:file_id}
  # DELETE /attached_files/{:file_id}.json
  def destroy
    if @attached_file.destroy
      if request.path == '/issues/' + @issue.id.to_s + '/edit'
        format.html { redirect_to "/issues/#{ @issue.id }/edit" }
      else
        format.html { redirect_to "/issues/#{ @issue.id }" }
      end
      format.json { render json: { message: "Files attached succesfully "}, status: :ok }
    else
      render json: { error: 'The attached file doesn\'t exist' }, status: :not_found
    end
  end

  private

  def set_issue_and_attached_file
    @attached_file = AttachedFile.find_by(id: params[:id])
    render json: { message: 'Attached file not found' }, status: :not_found if @attached_file.nil?
    if @attached_file
      @issue = Issue.find_by(id: @attached_file.issue_id)
      render json: { message: 'Issue related to attached file not found' }, status: :not_found if @issue.nil?
    end
  end
end
