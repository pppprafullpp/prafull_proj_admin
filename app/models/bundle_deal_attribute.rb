class BundleDealAttribute < ActiveRecord::Base
	belongs_to :deal
	has_many :bundle_equipments, dependent: :destroy
	accepts_nested_attributes_for :bundle_equipments,:reject_if => :reject_equipment, allow_destroy: true

	def reject_equipment(attributes)
		if attributes[:name].blank?
			if attributes[:id].present?
				attributes.merge!({:_destroy => 1}) && false
			else
				true
			end
		end
	end

	def self.get_linked_bundle_deal(category_id)
		#bundle_category_id = ServiceCategory.get_id_by_name(ServiceCategory::BUNDLE_CATEGORY)
		category_name = ServiceCategory.get_category_name_by_id(category_id)
		bundle_deals = Deal.find_by_sql("select deals.* from deals
															inner join bundle_deal_attributes bda on bda.deal_id = deals.id
															where bundle_combo like '%#{category_name}%'
															order by effective_price asc limit 5")
		bundle_deals
	end

end
