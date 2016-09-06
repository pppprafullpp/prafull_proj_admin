class AppUser < ActiveRecord::Base
  ## user type
  RESIDENCE = 'residence'
  BUSINESS = 'business'

  PRIMARY_ID = ["Driver License" , "Passport","State ID Card", "US Military Card", "US Military Department ID Card", "US Coast Guard Merchant Mariner Card", "EAD" ]
  SECONDARY_ID = ["Major credit card" , "Driver License","Passport"," State ID Card", "US Military Card", "US Military Department ID Card", "US Coast Guard Merchant Mariner Card", "EAD", "Birth certificate" ]
  USER_TYPES = [RESIDENCE,BUSINESS]

  def encrypt_data
    ##self.zip = encode_data({'data' => self.zip}) if self.zip.present?
  end

  def avatar_url
    avatar.url
  end
end
