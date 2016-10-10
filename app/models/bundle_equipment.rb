class BundleEquipment < ActiveRecord::Base
	belongs_to :bundle_deal_attribute
	belongs_to :deal
end
