class Favorite < ActiveRecord::Base
  attr_accessible :resource_id, :user_id
  validates_uniqueness_of :user_id, :uniqueness => {:scope => :resource_id}
  validates_presence_of :user_id, :allow_nil => false
  validates_presence_of :resource_id, :allow_nil => false
  validates_with FavoriteValidator
end
