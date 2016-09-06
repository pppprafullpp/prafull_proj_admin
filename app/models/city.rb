class City < ActiveRecord::Base
  has_many :city_locations,:dependent => :destroy

  def self.get_cities
    self.all.order("city_name").collect{|city| city.city_name}
  end
end
