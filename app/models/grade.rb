class Grade < ActiveRecord::Base
  has_many :resources
  attr_accessible :title
  validates_presence_of :title, :allow_nil => false
  validates_uniqueness_of :title, :allow_blank => false, :allow_nil => false, :case_sensitive => false
end
