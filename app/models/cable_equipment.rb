class CableEquipment < ActiveRecord::Base
	belongs_to :cable_deal_attribute
	belongs_to :deal
end
