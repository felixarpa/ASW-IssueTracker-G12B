class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /issues/:id/comments
  # GET /issues/:id/comments.json
  def index
    @comments = Comment.all
  end

  # GET /issues/:id/comments/1
  # GET /issues/:id/comments/1.json
  def show
  end

  # POST /issues/:id/comments
  # POST /issues/:id/comments.json
  def create
    if current_user.nil?
      format.json { render json: { error:
                                       { message: 'Unauthorized' }
      }, status: :unauthorized }
    else
      @comment = Comment.new(comment_params)
      @comment.user = current_user
      @comment.issue = @issue

      respond_to do |format|
        if @comment.save
          format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
          format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /issues/:id/comments/1
  # PATCH/PUT /issues/:id/comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
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
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by(id: params[:comment_id])
      @issue = Issue.find_by(id: params[:id])
      if @comment.nil?
        respond_to do |format|
          format.json { render json: { error:
                                           { message: 'Comment does not exist' }
          }, status: :not_found }
        end
      elsif @issue.nil?
        respond_to do |format|
          format.json { render json: { error:
                                           { message: 'Issue does not exist' }
          }, status: :not_found }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body)
    end
end
