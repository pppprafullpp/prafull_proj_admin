class AutoToken < ActiveRecord::Base
  belongs_to :tokenable, polymorphic: true
  
  def self.generate_token
    SecureRandom.urlsafe_base64(15)
  end
  
  def self.validate_token(obj, token)
    self.where("tokenable_type = ? AND token = ? AND status =?", eval(obj), token, ACTIVE_STATUS).first
  end
  
end
