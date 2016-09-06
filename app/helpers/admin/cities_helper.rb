module Admin::CitiesHelper

  def get_locations(seo_city = 'new-delhi')
    locations = CityLocation.find_by_sql("select concat(seo_city,'_',seo_location) as location, location as name, seo_city, seo_location, cl.id
                                          from city_locations cl
                                          inner join cities on cities.id = cl.city_id WHERE seo_city = '#{seo_city}' ORDER BY seo_location ASC ")
    
    location_hash = {}
    locations.each do |l|
      #location_hash[l.name] = "#{l.seo_city}_#{l.seo_location}"
      location_hash[l.name] = "#{l.location}"
    end
    location_hash
  end
 
  
end
