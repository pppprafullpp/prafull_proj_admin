class AppUser < ActiveRecord::Base
  ##include Encrypt
  #before_save :encrypt_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable,:recoverable, :rememberable, :trackable
  has_many :service_preferences, dependent: :destroy
  has_one :notification, dependent: :destroy
  has_many :comment_ratings, dependent: :destroy
  has_many :subscribe_deals, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :user_gifts,:dependent => :destroy
  has_many :gifts, through: :user_gifts
  has_many :referrals, :class_name => "AccountReferral", :foreign_key => "referral_id",dependent: :destroy
  has_one :referrer, :class_name => "AccountReferral", :foreign_key => "referrer_id",dependent: :destroy
  has_many :app_user_addresses, dependent: :destroy
  has_many :business_app_users, dependent: :destroy
  has_many :refer_contact_details
  #has_many :comments, dependent: :destroy
  #has_many :ratings, dependent: :destroy
  #mount_uploader :avatar, ImageUploader

  # before_save :encode_data
  ##before_save :encrypt_data
  validates :email, :presence => true, :uniqueness => true
  # validates :password, :presence => true, :confirmation => true, :on => :create

  ## user type
  RESIDENCE = 'residence'
  BUSINESS = 'business'

  PRIMARY_ID = ["Driving License" , "Passport","State ID Card", "US Military Card", "US Military Department ID Card", "US Coast Guard Merchant Mariner Card", "EAD" ]
  SECONDARY_ID = ["Major credit card" , "Driving License","Passport"," State ID Card", "US Military Card", "US Military Department ID Card", "US Coast Guard Merchant Mariner Card", "EAD", "Birth certificate" ]
  USER_TYPES = [RESIDENCE,BUSINESS]
  # STATES = Statelist.all.pluck(:state).uniq
    STATES = Statelist.all.order('state ASC').pluck(:state).uniq

  def self.search(params)
    conditions = []
    conditions << "first_name like '%#{params[:first_name]}%' or last_name like '%#{params[:first_name]}%'" if params[:first_name].present?
    conditions << "user_type = '#{params[:user_type]}'" if params[:user_type].present?
    conditions << "mobile = '#{params[:mobile]}'" if params[:mobile].present?
    conditions << "email like '%#{params[:email]}%'" if params[:email].present?
    condition = conditions.join(' and ')
    self.where(condition)
  end

  def encrypt_data
    ##self.zip = encode_data({'data' => self.zip}) if self.zip.present?
  end

  def avatar_url
    avatar.url
  end

  def as_json(opts={})
    json = super(opts)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  end

  def self.encrypt(password)
    Digest::SHA1.hexdigest("#{password}")
  end

  def self.authenticate(email, password)
    user = self.select('id,first_name,last_name,email,encrypted_password,active,zip,user_type').where(:email => email).first
    if user.present? && password.present?
      user.valid_password?(password) ? user : nil
    else
      nil
    end
  end


  def self.get_addresses(params)
    app_user = AppUser.find_by_id(params[:id])
    addresses_array = []
    addresses = app_user.business_app_users.last.business.business_addresses if app_user.user_type == AppUser::BUSINESS
    addresses = app_user.app_user_addresses if app_user.user_type == AppUser::RESIDENCE
    addresses_array << addresses.where(address_type: BusinessAddress::BILLING_ADDRESS).order('updated_at DESC').first
    addresses_array << addresses.where(address_type: BusinessAddress::SHIPPING_ADDRESS).order('updated_at DESC').first
    addresses_array << addresses.where(address_type: BusinessAddress::BRANCH_ADDRESS).order('updated_at DESC').first
  end


  def self.update_app_user(params,app_user_id,order = nil)

    app_user = self.where(:id => app_user_id).first
    params[:app_user].each do |key,value|
      app_user[key] = value unless key == 'email'
    end
    if order.present?
      app_user.primary_id = order.primary_id
      app_user.secondary_id = order.secondary_id
      app_user.primary_id_number = order.primary_id_number
      app_user.secondary_id_number = order.secondary_id_number
    end
    if app_user.save!
      app_user
    else
      app_user
    end
  end

  def self.create_new_user(params)
    users = []
    users_param = params[:app_user]
    if users_param.present?
      users_param.each do |user|
        user_record = self.new
        user.each do |key,value|
          user_record[key] = value
        end
        if user_record.save!
          users << user_record
        end
      end
      users
    end
  end

end
