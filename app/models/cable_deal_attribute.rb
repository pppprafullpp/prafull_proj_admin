class CableDealAttribute < ActiveRecord::Base
	belongs_to :deal
	has_many :cable_equipments, dependent: :destroy
	accepts_nested_attributes_for :cable_equipments,:reject_if => :reject_equipment, allow_destroy: true
	before_save :update_channel_count


	def channel_name
    Channel.select('id,channel_name').where(id: eval(self.channel_ids))
  end
	

	def reject_equipment(attributes)
		if attributes[:name].blank?
			if attributes[:id].present?
				attributes.merge!({:_destroy => 1}) && false
			else
				true
			end
		end
	end


	private
	def update_channel_count
		self.channel_count = eval(self.channel_ids).count if self.channel_ids.present?
	end
end
