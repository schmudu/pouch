class Resource < ActiveRecord::Base
  attr_accessible :description, :title, :attachments_attributes

  belongs_to :user
  has_many :attachments, :as => :attachable

  accepts_nested_attributes_for :attachments
end
