class InternetEquipment < ActiveRecord::Base
	belongs_to :internet_deal_attribute
	belongs_to :deal
end
