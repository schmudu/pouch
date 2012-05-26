class ResourceValidator < ActiveModel::Validator
  def validate(record)
    #validate that attachments is not empty
    if(record.attachments.nil?)
      record.errors[:attachments] << "Resource must have at least one attachment."
    elsif record.attachments.kind_of?(Array)
      record.errors[:attachments] << "Resource must have at least one attachment." if record.attachments.empty?
    end

    #description must be a certain length
    record.errors[:description] << "Description must be at least #{ConstantsHelper.RESOURCE_DESCRIPTION_MIN_LENGTH} characters." if record.description.length < ConstantsHelper.RESOURCE_DESCRIPTION_MIN_LENGTH
  end
end