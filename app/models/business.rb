class Business < ActiveRecord::Base
  has_many :business_addresses
  has_many :business_app_users
  #validates :business_name,:uniqueness => true
  #validates :business_name, uniqueness: { scope: :federal_number }
 #  before_save {
 #   self.business_name = business_name.squish if business_name.present?
 #   self.federal_number=Base64.encode64(federal_number) if federal_number.present?
 #   self.ssn=Base64.encode64(ssn) if ssn.present?
 #   self.db_number=Base64.encode64(db_number) if db_number.present?
 #   self.business_name=Base64.encode64(business_name) if business_name.present?
 #   self.manager_name=Base64.encode64(manager_name) if manager_name.present?
 #   self.manager_contact=Base64.encode64(manager_contact) if manager_contact.present?
 # }
  ## business type
  SOLE_PROPRIETOR = 0
  REGISTERED = 1

  BUSINESS_TYPES = {'Sole Proprietor' => SOLE_PROPRIETOR, 'Registered' => REGISTERED}

  ## business status
  NEW = 'New'
  EXISTING = 'Existing'
  RECONTRACTED = 'Recontracted'
  RENEWAL = 'Renewal'
  UPGRADE = 'Upgrade'

  def self.create_business(params)
    # raise params.to_yaml
    if params[:business].present?
      business_type = params[:business][:business_type].present? ? params[:business][:business_type].to_i : nil
      if business_type.present?
        if business_type == SOLE_PROPRIETOR
          business = self.where("ssn = ? OR business_name = ? ",params[:business][:ssn], params[:business][:business_name]).first if params[:business][:ssn].present? or params[:business][:business_name].present?
        elsif business_type == REGISTERED
          business = self.where("federal_number = ? OR business_name = ? ",params[:business][:federal_number], params[:business][:business_name]).first if params[:business][:federal_number].present? or params[:business][:business_name].present?
        end
        business = self.where(:id => params[:business][:id]).first if params[:business][:id].present? and !business.present?
        unless business.present?
          business = self.new
        else
          business = business
        end
        params[:business].each do |key,value|
          business[key] = value
        end
        if business.save!
          business
        else
          business
        end
      end
    else
      nil
    end
  end

  def self.get_business_by_user(user_id)
    Business.select('businesses.*').joins(:business_app_users).where("business_app_users.app_user_id = ?",user_id).first
  end

end
