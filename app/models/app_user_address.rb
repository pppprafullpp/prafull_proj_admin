class AppUserAddress < ActiveRecord::Base
  belongs_to :app_user
  before_save { self.address_name = address_name.squish if address_name.present?}
  def self.create_app_user_addresses(params,app_user_id)
    app_user_addresses = []
    params[:app_user_addresses].each do |address|
      app_user_address = self.where(:address_name => address[:address_name],:address_type => address[:address_type],:app_user_id => app_user_id).first
      unless app_user_address.present?
        app_user_address = self.new
      end
      app_user_address.app_user_id = app_user_id
      address.each do |key,value|
        app_user_address[key] = value
      end
      if app_user_address.save!
        app_user_addresses << app_user_address
      end
    end
    app_user_addresses
  end

end