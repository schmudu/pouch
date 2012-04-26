class UserValidator < ActiveModel::Validator
  def validate(record)
    #validate password
    unless record.password.nil?
      if !record.password.has_lowercase_letter?
        record.errors[:password] << "Password must have at least one lowercase letter."
      end
      
      if !record.password.has_uppercase_letter?
        record.errors[:password] << "Password must have at least one uppercase letter."
      end

      if !record.password.has_digit?
        record.errors[:password] << "Password must have at least one number."
      end
    end
  end
end