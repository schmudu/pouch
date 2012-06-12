class Grade < ActiveRecord::Base
  has_many :resource_grades
  has_many :resources, through: :resource_grades
  attr_accessible :title
  validates_presence_of :title, :allow_nil => false
  validates_uniqueness_of :title, :allow_blank => false, :allow_nil => false, :case_sensitive => false
end
