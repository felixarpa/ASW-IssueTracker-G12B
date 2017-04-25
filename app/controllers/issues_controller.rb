class IssuesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_auth
  before_action :set_issue, only: [:show, :edit, :update, :destroy, :attach]

  attr_accessor :assignee

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.all.order(sort_column + ' ' + sort_direction)
    @issues = @issues.where(kind: params[:kind]) if params[:kind]
    @issues = @issues.where(priority: params[:priority]) if params[:priority]
    @issues = @issues.where(status: params[:status]) if params[:status]

    if params[:responsible]
      @user = User.find_by(nickname: params[:responsible])
      @issues = @issues.to_a
      if @user.nil?
        @issues.clear
      else
        @issues = @issues.select { |i| i.assignee.equal?(@user) }
      end
    end

    if params[:watching]
      @user = User.find_by(nickname: params[:watching])
      @issues = @issues.to_a
      if @user.nil?
        @issues.clear
      else
        @issues = @issues.select { |i| i.watchers.exists?(@user.id) }
      end
    end

  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @comments = @issue.comments
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
    @issue.assignee = User.find_by(id: @issue.assignee_id)

    respond_to do |format|
      if @issue.save

        if params[:attached_files]
          params[:attached_files].each {|attached_file|
            @issue.attached_files.create(file: attached_file)
          }
        end

        format.html {redirect_to @issue, notice: 'Issue was successfully updated.'}
        format.json {render :show, status: :created, location: @issue}
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

        if params[:attached_files]
          params[:attached_files].each {|attached_file|
            @issue.attached_files.create(file: attached_file)
          }
        end

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
    @issue.destroy
    respond_to do |format|
      format.html {redirect_to issues_url, notice: 'Issue was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = Issue.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def issue_params
    params.fetch(:issue, {}).permit(:title, :description, :kind, :priority, :status, :assignee_id)
  end

  def sort_column
    Issue.column_names.include?(params[:sort]) ? params[:sort] : ''
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

  def set_auth
    @auth = session[:omniauth] if session[:omniauth]
  end
end
