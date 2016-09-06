class ApiToken < ActiveRecord::Base
  before_create :generate_access_token
  
  def self.token_valid?(token, device_id)
    return false if token.blank?
    
    unless token.class == self
      token = ApiToken.find_by_token_and_device_id(token, device_id)
    end
    
    if token.blank? || (Time.now.in_time_zone - token.created_at) > 2.hours
      return false
    end
    
    return true
  end
  
  private
  def generate_access_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end
end
