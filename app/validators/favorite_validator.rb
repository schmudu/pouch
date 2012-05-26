class FavoriteValidator < ActiveModel::Validator
  def validate(record)
    #validate that user exists
    user = User.find_by_id(record.user_id)
    record.errors[:user_id] << "User id does not reference any user that exists." if user.nil?

    #validate that record exists
    resource = Resource.find_by_id(record.resource_id)
    record.errors[:resource_id] << "Resource id does not reference any resource that exists." if resource.nil?
  end
end