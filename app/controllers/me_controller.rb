class MeController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: current_user, status: :ok }
    end
  end
end
