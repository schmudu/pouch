class ResourceValidator < ActiveModel::Validator
  def validate(record)
    #validate that attachments is not empty
    record.errors[:attachments] << "Resource must have at least one attachment." if record.attachments.empty?
  end
end