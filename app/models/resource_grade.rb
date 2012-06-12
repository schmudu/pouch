class ResourceGrade < ActiveRecord::Base
  belongs_to :resource
  belongs_to :grade
  attr_accessible :resource_id, :grade_id
  validates_presence_of :resource_id, :allow_nil => false
  validates_presence_of :grade_id, :allow_nil => false
  validates_uniqueness_of :resource_id, :scope => :grade_id
end
