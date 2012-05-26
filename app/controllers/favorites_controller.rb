class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  def create
    favorite = Favorite.new(:user_id => current_user.id, :resource_id => params[:id])

    if favorite.save
      respond_to do |format|
        #format.html # should not call this
        #format.json { render json: @resource }
        format.js
      end 
    else
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
