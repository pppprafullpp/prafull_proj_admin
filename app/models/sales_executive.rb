class SalesExecutive < ActiveRecord::Base
  has_attached_file :upload, :styles => { :medium => "200x200>", :thumb => "100x100>" }
  SALES_EXECUTIVE = "sales_executive"

  def self.encrypt(password)
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+password
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

  def self.generate_random_password
    ('a'..'z').to_a.shuffle.first(8).join
  end

  def self.create_profile(params)
    sales_executive = self.find_or_initialize_by(:name => params[:name], :email => params[:email])
    if sales_executive.new_record?
        sales_executive.enabled = params[:enabled]
        password = encrypt(generate_random_password)
        sales_executive.encrypted_password = password
        sales_executive.role = "sales_executive"
        sales_executive.save
    end
      sales_executive
  end

  end
