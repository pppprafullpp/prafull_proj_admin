class BusinessAppUser < ActiveRecord::Base
  belongs_to :business
  belongs_to :app_user

  def self.create_business_app_user(business_id,app_user_id,role = 0)
    business_app_user = self.where(:business_id => business_id,:app_user_id => app_user_id).first
    unless business_app_user.present?
      business_app_user = self.new
      business_app_user.business_id = business_id 
      business_app_user.app_user_id = app_user_id
      business_app_user.role = role
      if business_app_user.save!
        business_app_user
      else
        business_app_user
      end
    else
      business_app_user
    end
  end

end
