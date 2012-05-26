class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  def create
    favorite = Favorite.new(:user_id => current_user.id, :resource_id => params[:id])

    if favorite.save
      logger.debug("\n\nsaved favorite.")
      respond_to do |format|
        #format.html # should not call this
        #format.json { render json: @resource }
        format.js
      end 
    else
      #logger.debug("\n\nnot working!errors: #{favorite.errors}")
      favorite.errors.each {|k, e| logger.debug("\n===error: #{e}\n")}
      render :json => "doesn't work."
    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    @id = params[:id]
    respond_to do |format|
      #format.html { redirect_to account_path }
      #format.json { head :no_content}
      format.js 
    end 
  end

  def index
    @favorites = Favorite.find(:all, :conditions => ["user_id = ?", current_user.id])
  end
end
