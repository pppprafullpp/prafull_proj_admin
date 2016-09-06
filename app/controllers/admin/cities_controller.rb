class Admin::CitiesController < ApplicationController
  def get_city_details
    if params[:city_id].present?
      city_id = params[:city_id]
      @address_for = params[:address_for] # this variable is used to make dynamic attribute for doctor,user,lab address
      @city = City.where(:seo_city => city_id).first if city_id.present?
      @city_location_id = params[:clid]
      @city_locations = {}
      locations = @city.city_locations
      locations.each do |l|
        @city_locations[l.location] = l.seo_location
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def get_location_details
    location_id = params[:location_id]
    location = CityLocation.where(:seo_location => location_id).first
    respond_to do |format|
      format.html {render :nothing => true }
      format.js { render :json => {:location => location,:layout => false}.to_json}
    end
  end

end
