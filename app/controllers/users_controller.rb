class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:account]
  def account
    @resources = Resource.where(:user_id => current_user.id).sort_by{|r| r.title }
    @favorites = Favorite.where(:user_id => current_user.id).sort_by{|f| f.created_at }
  end
end
