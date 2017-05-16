class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :set_issue
  skip_before_action :authenticate_request, only: [:index, :show]

  # GET /issues/:id/comments
  # GET /issues/:id/comments.json
  def index
    comments = @issue.comments
    comments.order('created_at asc')
    respond_to do |format|
      format.json { render json: comments, status: :ok }
    end
  end

  # GET /issues/:id/comments/1
  # GET /issues/:id/comments/1.json
  def show
    respond_to do |format|
      format.json { render json: @comment, status: :ok }
    end
  end

  # POST /issues/:id/comments
  # POST /issues/:id/comments.json
  def create
    comment = Comment.new(comment_params)
    comment.user = current_user
    comment.issue = @issue

    respond_to do |format|
      if comment.save
        format.html { redirect_to comment, notice: 'Comment was successfully created.' }
        format.json { render json: comment, status: :created }
      else
        format.html { render :new }
        format.json { render json: comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/:id/comments/1
  # PATCH/PUT /issues/:id/comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render json: @comment, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/:id/comments/1
  # DELETE /issues/:id/comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json {render json: {message: 'Comment deleted successfully'},
                          status: :ok}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by(id: params[:comment_id])
      if @comment.nil?
        respond_to do |format|
          format.json { render json: { error: 'Comment not found' },
                               status: :not_found }
        end
      end
    end

  def set_issue
    @issue = Issue.find_by(id: params[:id])
    if @issue.nil?
      respond_to do |format|
        format.json { render json: { error: 'Issue not found' },
                             status: :not_found }
      end
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.permit(:body)
    end
end
