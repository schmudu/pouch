class UserResourceView < ActiveRecord::Base
  attr_accessible :resource_id, :user_id
  belongs_to :resource
  belongs_to :user
end
