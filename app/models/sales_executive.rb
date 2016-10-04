class SalesExecutive < ActiveRecord::Base
  has_attached_file :upload, :styles => { :medium => "200x200>", :thumb => "100x100>" }

  SALES_EXECUTIVE = "sales_executive"

  def self.encrypt(password)
    Digest::SHA1.hexdigest("#{password}")
  end

  def self.authenticate(username, password)
    password = encrypt(password)
    username.present? && password.present? ? self.where("email = ?  AND encrypted_password = ?", username, password) : nil
  end

  def self.search(params)
    # raise params.to_yaml
    conditions = []
    conditions << "name like '%#{params[:name]}%'" if params[:name].present?
    conditions << "email like '%#{params[:email]}%'" if params[:email].present?
    conditions << "enabled = '#{params[:enabled]}'" if params[:enabled].present?
    condition = conditions.join(' and ')
    self.where(condition)
  end

end
