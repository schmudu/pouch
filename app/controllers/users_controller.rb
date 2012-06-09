class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:account]
  def account
    @resources = Resource.where(:user_id => current_user.id).sort_by{|r| r.title }
    #@favorites = Favorite.where(:user_id => current_user.id).sort_by{|f| f.created_at }
    @favorite_resources = Resource.find(:all, :joins => "resources inner join favorites as f on resources.id = f.resource_id", :include => :favorites, :conditions => ["f.user_id=?",3]).sort_by{|r| r.title }
  end
end
