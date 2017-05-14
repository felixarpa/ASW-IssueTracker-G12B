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

    @issues = @issues.where(assignee_id: User.find_by(nickname:
                              params[:responsible]).id) if params[:responsible]

    if params[:watching]
      @user = User.find_by(nickname: params[:watching])
      @issues = @issues.to_a
      if @user.nil?
        @issues.clear
      else
        @issues = @issues.select { |i| i.watchers.exists?(@user.id) }
      end
    end

    if params[:sort] and params[:direction]
      @issues.order(params[:sort] + ' ' + params[:direction])
    end

    respond_to do |format|
      format.html
      format.json { render json: @issues, status: :ok, each_serializer:
          IndexIssueSerializer }
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @comments = @issue.comments if @issue
    respond_to do |format|
      format.html
      if @issue
        format.json { render json: @issue, status: :ok,
                             serializer: ShowIssueSerializer }
      else
        format.json { render json: { error:
                                         { message: 'Issue does not exist' }
        }, status: :not_found }
      end
    end
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues/1/attach
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
          @attachments.each do |a| @issue.attached_files.create(file: a) end
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
    if @issue.user != current_user && !issue_params.empty?
      return render json: { error: 'Operation not permitted'}, status: 403
    end

    respond_to do |format|
      if @issue.update(issue_params)
        if @attachments
          @attachments.each do |a| @issue.attached_files.create(file: a) end
        end

        format.html {redirect_to @issue, notice: 'Issue was successfully updated.'}
        format.json {render json: @issue, status: :ok, serializer:
            ShowIssueSerializer}
      else
        format.html {render :edit}
        format.json {render json: { error: 'Couldn\'t update issue' }, status:
            :unprocessable_entity}
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    if @issue.user != current_user
      return render json: { error: 'Operation not permitted'}, status: 403
    end
    @issue.destroy
    respond_to do |format|
      format.html {redirect_to issues_url, notice: 'Issue was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = Issue.find_by(id: params[:id])
    render json: { message: 'Issue not found' }, status: :not_found if @issue.nil?
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
    if params[:attached_files]
      params[:attached_files].each do |f|
        return render json: { error: 'Missing attachment parameters' }, status: :bad_request unless f[:name] && f[:content]
      end
    end

    @attachments = []
    params[:attached_files].each do |f|
      attachment = f
      attachment = parse_attachment(f) unless f.is_a?(ActionDispatch::Http::UploadedFile)
      @attachments << attachment
    end
  end

  def parse_attachment(attachment_data)
    attachment = Paperclip.io_adapters.for(attachment_data[:content])
    attachment.original_filename = attachment_data[:name]
    attachment
  rescue
    return render json: { error: 'Invalid attachment' }, status: :bad_request
  end
end
