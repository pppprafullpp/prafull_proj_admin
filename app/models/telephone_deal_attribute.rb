class TelephoneDealAttribute < ActiveRecord::Base
	belongs_to :deal
	has_many :telephone_equipments, dependent: :destroy
    accepts_nested_attributes_for :telephone_equipments,:reject_if => :reject_equipment, allow_destroy: true
  
  	def reject_equipment(attributes)
	    if attributes[:name].blank?
	      if attributes[:id].present?
	        attributes.merge!({:_destroy => 1}) && false
	      else
	        true
	      end
	    end
	end
end
