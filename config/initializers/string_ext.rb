class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end
  
  def to_sex
    return 'male' if self == 'male' || self =~ (/(male|m)$/i)
    return 'female' if self == 'female' || self.blank? || self =~ (/(female|f)$/i)
    raise ArgumentError.new("invalid value for Sex: \"#{self}\"")
  end
end