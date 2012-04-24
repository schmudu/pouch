class UserValidator < ActiveModel::Validator
  def validate(record)
    #validate password
    unless record.password.nil?
      if record.password == 'aaaaaa'
        record.errors[:password] << "Password is too simple."
      end
    end
  end
end