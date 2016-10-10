class TelephoneEquipment < ActiveRecord::Base
		belongs_to :telephone_deal_attribute
		belongs_to :deal
end
