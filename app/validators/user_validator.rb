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

    #validate number of users created from this ip address - anti-bot
    users = User.select{|u| ((record.created_ip == u.created_ip) && (u.created_at > (Time.now - ConstantsHelper::MAX_USERS_FROM_IP.minutes)))}
    record.errors[:password] << "Too many users have been registered from this address." if users.length>=ConstantsHelper::MAX_USERS_FROM_IP
  end
end