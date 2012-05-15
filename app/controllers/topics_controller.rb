class TopicsController < ApplicationController
    # GET /resources
  # GET /resources.json
  def index
    @topics = Topic.order(:name)
    respond_to do |format|
      #format.html # index.html.erb
      format.json { render json: @topics.tokens(params[:q]) }
    end
  end
end