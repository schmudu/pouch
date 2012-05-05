class Attachment < ActiveRecord::Base
  attr_accessible :file, :file_cache, :downloads
  #attr_accessor :file_cache

  has_many :user_attachment_downloads
  belongs_to :attachable, :polymorphic => true
  
  mount_uploader :file, FileUploader

  validates_with AttachmentValidator
  def increment_download_counter
    self.update_attribute(:downloads, downloads + 1)
  end
end
