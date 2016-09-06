class SearchesController < ApplicationController
  layout 'empty'
  
  def location_by_city
      locations = CityLocation.find_by_sql("select concat(seo_city,'_',seo_location) as location, location as name, seo_city, seo_location, cl.id
                                          from city_locations cl
                                          inner join cities on cities.id = cl.city_id WHERE seo_city = '#{params[:city]}' ORDER BY seo_location ASC ")
    
      render json: locations, layout: false    
  end


end