class Admin < ActiveRecord::Base
  
  has_many :admin_meetings, :dependent => :destroy
  has_many :login_details, :as => :partnerable

  ADMIN_ID = 1
  has_attached_file :upload, :styles => { :medium => "200x200>", :thumb => "100x100>" }

  def self.encrypt(password)
    Digest::SHA1.hexdigest("#{password}")
  end

  def self.authenticate(username, password)
    password = encrypt(password)
    username.present? && password.present? ? self.where("email = ?  AND password = ?", username, password) : nil
  end

end
