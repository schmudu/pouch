class String
  def has_uppercase_letter?
    return false if (self =~ /[A-Z]/).nil?
    return true
  end

  def has_lowercase_letter?
    return false if (self =~ /[a-z]/).nil?
    return true
  end

  def has_digit?
    return false if (self =~ /\d/).nil?
    return true
  end

  def extract_grade_id 
    self[(self.to_s =~ /\d/),self.to_s.length]
  end
end