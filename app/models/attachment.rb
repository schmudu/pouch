require 'file_size_validator' 
class Attachment < ActiveRecord::Base
  #Note: Because we are using nested form, we can not add any validators to the file attribute
  attr_accessible :file, :file_cache, :downloads
  #attr_accessor :file_cache

  has_many :user_attachment_downloads
  belongs_to :attachable, :polymorphic => true
  
  mount_uploader :file, FileUploader
  validates :file, 
    :presence => true, 
    :file_size => { 
      :maximum => 5.megabytes.to_i 
    } 
  #validates_with AttachmentValidator
  # def increment_download_counter
  #   self.update_attribute(:downloads, downloads + 1)
  # end
end
