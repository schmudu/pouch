class UserAttachmentDownload < ActiveRecord::Base
  attr_accessible :attachment_id, :user_id

  belongs_to :attachment
  belongs_to :user
end
