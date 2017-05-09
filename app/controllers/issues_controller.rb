class IssuesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_issue, only: [:show, :edit, :update, :destroy, :attach]
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
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @comments = @issue.comments if @issue
    respond_to do |format|
      format.html
      if @issue
        format.json { render json: @issue, status: :ok }
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

        if params[:attached_files]
          params[:attached_files].each {|attached_file|
            @issue.attached_files.create(file: attached_file)
          }
        end

        format.html {redirect_to @issue, notice: 'Issue was successfully updated.'}
        format.json {render json: @issue, status: :created}
      else
        format.html {render :new}
        format.json {render json: @issue.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    if params[:attached_files]
      params[:attached_files].each {|attached_file|
        @issue.attached_files.create(file: attached_file)
      }
    end
    if @issue.user != current_user && !issue_params.empty?
      return render json: { error: 'Operation not permitted'}, status: 403
    end
    respond_to do |format|
      if @issue.update(issue_params)

        format.html {redirect_to @issue, notice: 'Issue was successfully updated.'}
        format.json {render :show, status: :ok, location: @issue}
      else
        format.html {render :edit}
        format.json {render json: @issue.errors, status: :unprocessable_entity}
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
end
