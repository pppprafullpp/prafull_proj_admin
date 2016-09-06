class User < ActiveRecord::Base
  ratyrate_rater
  #acts_as_commontator

  attr_accessor :token
  
  validates :email,:mobile,:uniqueness => true
  validates :email,:mobile,:first_name, :presence => true
  validates :email,:email_format => { :message => 'not a valid email address' }
  validates :password, :presence => true
  validates :password, :confirmation => true, :presence => true, :on => :create

  scope :active, -> { where(status: ACTIVE_STATUS) }

  has_many :user_addresses,:dependent => :destroy
  has_many :lab_orders,:dependent => :destroy
  has_many :lab_test_requests,:dependent => :destroy
  has_one :user_social_login_detail,:dependent => :destroy
  has_many :auto_tokens, as: :tokenable
  has_many :feedbacks,:dependent => :destroy
  has_many :login_details, :as => :partnerable
  
  has_many :appointments
  has_many :doctors, through: :appointments

  has_attached_file :upload, :styles => { :medium => "200x200>", :thumb => "100x100>" },
                             :path => "public/system/users/:user_id/photo/:filename",
                             :url => "/system/users/:user_id/photo/:basename.:extension"
                             
  validates_attachment :upload, content_type: { content_type: /\Aimage\/.*\Z/ },
                               size: { less_than: IMAGE_LIMIT.megabytes }
                             
                         

  before_create :set_status
  before_create :set_sex
  before_create :encrypt_password
  extend Notify
  ## CONTANTS for Prefix##
  MR = 'Mr.'
  MRS = 'Mrs.'
  MISS = 'Miss'


  def self.authenticate(username, password)
    password = Admin::encrypt(password)
    username.present? && password.present? ? self.where("(email = ?  OR mobile = ? )AND password = ?", username, username, password).first : nil
  end

  def self.search(params)
    conditions = []
    conditions << "(first_name ilike '%#{params[:first_name]}%' or last_name ilike '%#{params[:first_name]}%')" if params[:first_name].present?
    conditions << "mobile ilike '%#{params[:mobile]}%'" if params[:mobile].present?
    conditions << "email ilike '%#{params[:email]}%'" if params[:email].present?
    condition = conditions.join(' and ')
    self.where(condition)
  end

  def self.generate_random_password
    ('0'..'z').to_a.shuffle.first(8).join
  end

  ## called from lab_order create to create doctor by lab guys
  def self.create_user(params)
    mobile = params[:mobile]
    name = params[:first_name].split(' ')
    first_name = name[0]
    last_name = name[1..4].join(' ')
    prefix = params[:prefix].present? ? params[:prefix] : User::MR
    email = params[:email]
    user = self.find_or_initialize_by(:mobile => mobile)
    if user.new_record?
      user.prefix = prefix
      user.first_name = first_name
      user.last_name = last_name
      user.email = email
      password = generate_random_password
      user.password = password
      user.save
      user.password = password ## reassigning for use in email and sms
      notify(user,USER,WELCOME_NOTIFICATION,true,{:email => true,:password => password})
    end
    user
  end

  def self.fetch_lab_patients(current_user)
    role = current_user.class.to_s

    if role.eql? Admin::ADMIN
      self.all
    elsif role.eql? Admin::LAB
      if current_user.lab_id.present?
        self.where("lab_orders.lab_id = ?", current_user.id)
      else
        lab_ids =  Lab.where("id = ? OR lab_id = ?", current_user.id, current_user.id).collect{|lab| lab.id}
        self.where("lab_orders.lab_id  IN (?)", lab_ids)
      end
    end
  end

  protected
  def encrypt_password
    self.password = Admin.encrypt(self.password)
  end

  def set_status
    self.status = ACTIVE_STATUS
  end

  def set_sex
    if [User::MRS,User::MISS].include?(self.prefix)
      sex = FEMALE
    else
      sex = MALE
    end
    self.sex = sex
  end

end
