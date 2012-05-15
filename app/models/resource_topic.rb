class ResourceTopic < ActiveRecord::Base
  belongs_to :resource
  belongs_to :topic
  attr_accessible :resource_id, :topic_id
  validates_presence_of :resource_id, :allow_nil => false
  validates_presence_of :topic_id, :allow_nil => false
  validates_uniqueness_of :resource_id, :scope => :topic_id
end
