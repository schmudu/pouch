class FirstUser < ActiveRecord::Base
  attr_accessible :email
  validates :email, :presence => true, :allow_blank => false, :allow_nil => false
  validates_uniqueness_of :email
end
