class Attachment < ActiveRecord::Base
  attr_accessible :file, :download_count, :file_cache
  #attr_accessor :file_cache

  belongs_to :attachable, :polymorphic => true
  
  mount_uploader :file, FileUploader

  validates_with AttachmentValidator
  def increment_download_counter
    self.update_attribute(:download_count, download_count + 1)
  end
end
