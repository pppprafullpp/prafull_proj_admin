class Zipcode < ActiveRecord::Base
	validates_uniqueness_of :code
	has_and_belongs_to_many :deals

end
