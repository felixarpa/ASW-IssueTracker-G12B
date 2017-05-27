class IssuesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_issue, only: [:show, :edit, :update, :destroy, :attach]
  before_action :prepare_attachments, only: [:create, :update]
  skip_before_action :authenticate_request, only: [:index, :show]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.all.order(sort_column + ' ' + sort_direction)
    @issues = @issues.where(kind: params[:kind]) if params[:kind]
    @issues = @issues.where(priority: params[:priority]) if params[:priority]
    @issues = @issues.where(status: params[:status]) if params[:status]

    if params.has_key?(:responsible)
      if User.exists?(nickname: params[:responsible])
        @issues = @issues.where(assignee_id: User
                                   .find_by(nickname: params[:responsible]).id)
      else
        @issues = []
      end
    end

    if params[:watching]
      @user = User.find_by(nickname: params[:watching])
      @issues = @issues.to_a
      if @user.nil?
        @issues.clear
      else
        @issues = @issues.select {|i| i.watchers.exists?(@user.id)}
      end
    end

    respond_to do |format|
      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IndexIssueSerializer}
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @comments = @issue.comments if @issue
    respond_to do |format|
      format.html
      format.json {render json: @issue, status: :ok, serializer: ShowIssueSerializer}
    end
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # GET /issues/1/attach
  def attach
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.user = current_user
    respond_to do |format|
      if @issue.save
        if @attachments
          @attachments.each do |a|
            @issue.attached_files.create(file: a)
          end
        end

        if params[:comment] and current_user
          comment = @issue.comments.new
          comment.user = current_user
          comment.body = params[:comment]
          comment.save
        end

        format.html {redirect_to @issue, notice: 'Issue was successfully updated.'}
        format.json {render json: @issue, status: :created, serializer:
            ShowIssueSerializer}
      else
        format.html {render :new}
        format.json {render json: @issue.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        if @attachments
          @attachments.each do |a|
            @issue.attached_files.create(file: a)
          end
        end

        create_comment

        format.html {redirect_to @issue, notice: 'Issue was successfully updated.'}
        format.json {render json: @issue, status: :ok, serializer: ShowIssueSerializer}
      else
        format.html {render :edit}
        format.json {render json: @issue.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html {redirect_to issues_url, notice: 'Issue was successfully destroyed.'}
      format.json {render json: {message: 'Issue deleted successfully'}, status: :ok}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = Issue.find_by(id: params[:id])
    render json: {error: 'Issue not found'}, status: :not_found if @issue.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def issue_params
    params.permit(:title, :description, :kind, :priority, :status, :assignee_id)
  end

  def sort_column
    Issue.column_names.include?(params[:sort]) ? params[:sort] : ''
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

  def prepare_attachments
    @attachments = []
    if params[:attached_files]
      params[:attached_files].each do |f|
        if f.is_a?(ActionDispatch::Http::UploadedFile)
          @attachments << f
        else
          return render json: {error: 'Missing attachment parameters'}, status: :bad_request unless f[:name] && f[:content]
          @attachments << parse_attachment(f)
        end
      end
    end
  end

  def parse_attachment(attachment_data)
    attachment = Paperclip.io_adapters.for(attachment_data[:content])
    attachment.original_filename = attachment_data[:name]
    attachment
  rescue
    return render json: {error: 'Invalid attachment'}, status: :bad_request
  end

  def create_comment
    comment_body = ''

    edited_params = []
    edited_params << 'title' if params[:title]
    edited_params << 'description' if params[:description]
    edited_params << 'kind' if params[:kind]
    edited_params << 'status' if params[:status]
    edited_params << 'priority' if params[:priority]

    added_attachments = []
    if @attachments
      @attachments.each do |f|
        added_attachments << f.original_filename
      end
    end

    new_assignee = nil
    unless params[:assignee_id].nil? || !User.exists?(params[:assignee_id])
      new_assignee = User.find_by(id: params[:assignee_id]).name
    end

    unless edited_params.empty?
      comment_body += '<p><ul><li>'
      comment_body += "<strong>#{current_user.name}</strong>"
      comment_body += ' has modified the issue attribute'
      comment_body += 's' if edited_params.size > 1
      comment_body += ' <i>' + edited_params.to_sentence + '</i>'
      comment_body += '</li>'
    end

    unless added_attachments.empty?
      if edited_params.empty?
        comment_body += '<p><ul><li>'
        comment_body += "<strong>#{current_user.name}</strong>"
      elsif new_assignee.nil?
        comment_body += ' and'
      else
        comment_body += ','
      end
      comment_body += ' has attached the file'
      comment_body += 's' if added_attachments.size > 1
      comment_body += ' <i>' + added_attachments.to_sentence + '</i>'
    end


    if params.has_key?(:assignee_id)
      if edited_params.empty? and added_attachments.empty?
        comment_body += '<p><ul><li>'
        comment_body += "<strong>#{current_user.name}</strong>"
      else
        comment_body += ' and'
      end

      if User.find_by(id: params[:assignee_id]).nil?
        comment_body += ' has removed the assignee'
      else
        comment_body += ' has assigned this issue to <strong>' + new_assignee + '</strong>'
      end
    end

    unless comment_body.empty?
      comment_body += '.'
      comment_body += '</li></ul></p>'
    end

    if params[:comment]
      comment_body += params[:comment]
    end

    unless comment_body.empty?
      comment = Comment.new
      comment.body = comment_body
      comment.issue = @issue
      comment.user = current_user
      comment.save
    end
  end
end
