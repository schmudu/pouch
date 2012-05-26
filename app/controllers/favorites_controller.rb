class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  def create
    favorite = Favorite.new(:user_id => current_user.id, :resource_id => params[:resource_id])

    if favorite.save
      respond_to do |format|
        format.html # should not call this
        #format.json { render json: @resource }
        format.json
      end 
    else
      render :json => "doesn't work."
    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    respond_to do |format|
      format.html { redirect_to account_path }
      format.json { head :no_content}
    end 
  end
end
