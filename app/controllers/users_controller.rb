class UsersController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: User.all, status: :ok }
    end
  end
end
