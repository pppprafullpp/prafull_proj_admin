class AdditionalOffer < ActiveRecord::Base
	belongs_to :deal
	
	has_and_belongs_to_many  :zipcodes, dependent: :destroy
  
end
