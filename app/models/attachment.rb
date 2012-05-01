class Attachment < ActiveRecord::Base
  attr_accessible :file, :description, :download_count

  belongs_to :attachable, :polymorphic => true
  
  mount_uploader :file, FileUploader

  validates_presence_of :description
  #validates_presence_of :file

  def increment_download_counter
    self.update_attribute(:download_count, download_count + 1)
  end
end
