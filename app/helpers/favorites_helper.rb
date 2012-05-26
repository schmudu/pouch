module FavoritesHelper
  def user_already_has_favorite?
    favorite = Favorite.find(:first, :conditions => ["user_id = ? and resource_id =?", current_user.id, params[:id]])
    return false if favorite.nil?
    return true
  end
end
