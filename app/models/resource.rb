class Resource < ActiveRecord::Base
  attr_accessible :description, :name
  mount_uploader :document, DocumentUploader
end
