class AttachmentValidator < ActiveModel::Validator
  def validate(record)
    #validate that attachments is not empty
    #record.errors[:attachments] << "Attachment must have a file attached to it." if record.file.url.nil?
  end
end