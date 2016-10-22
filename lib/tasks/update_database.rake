namespace :update_database do


  task update_effective_price_in_deals: :environment do
    deals = Deal.all
    deals.each do |deal|
      effective_price = deal.get_effective_price
      puts "--------------#{effective_price}------------"
      deal.update_attributes(:effective_price => effective_price)
    end
  end


  task update_effective_price_in_cellphone_deal_attributes: :environment do
    deals = CellphoneDealAttribute.all
    deals.each do |deal|
      deal.save!
    end
  end

  task create_multiline_deal_attribute_for_cellphone_deals: :environment do
    service_category = ServiceCategory.where(:name => ServiceCategory::CELLPHONE_CATEGORY).first
    deals = Deal.where(:service_category_id => service_category.id)
    deals.each do |deal|
      cellphone_deal_attribute = CellphoneDealAttribute.where(:deal_id => deal.id,:no_of_lines => 1).first
      if cellphone_deal_attribute.present?
        price_per_line = cellphone_deal_attribute.price_per_line
        data_plan_price = cellphone_deal_attribute.data_plan_price
        additional_data_price = cellphone_deal_attribute.additional_data_price
        domestic_call_minutes = cellphone_deal_attribute.domestic_call_minutes
        domestic_text = cellphone_deal_attribute.domestic_text
        international_call_minutes = cellphone_deal_attribute.international_call_minutes
        international_text = cellphone_deal_attribute.international_text
        data_plan = cellphone_deal_attribute.data_plan
        additional_data = cellphone_deal_attribute.additional_data
        rollover_data = cellphone_deal_attribute.rollover_data
        equipment=deal.cellphone_equipments.first
        for i in 2..4
          cellphone_deal_attribute_new = CellphoneDealAttribute.find_or_initialize_by(:deal_id => deal.id,:no_of_lines => i)
          effective_price=(i*price_per_line)+data_plan_price+additional_data_price
          if equipment.present?
            effective_price+=(i*equipment.price)
          end
          if deal.additional_offers.present?
            deal.additional_offers.each do |additional_offer|
              effective_price-=additional_offer.price
            end
          end
          cellphone_deal_attribute_new.effective_price = effective_price
          cellphone_deal_attribute_new.price_per_line = price_per_line
          cellphone_deal_attribute_new.data_plan_price = data_plan_price
          cellphone_deal_attribute_new.additional_data_price = additional_data_price
          cellphone_deal_attribute_new.domestic_call_minutes = domestic_call_minutes
          cellphone_deal_attribute_new.domestic_text = domestic_text
          cellphone_deal_attribute_new.international_call_minutes = international_call_minutes
          cellphone_deal_attribute_new.international_text = international_text
          cellphone_deal_attribute_new.data_plan = data_plan
          cellphone_deal_attribute_new.additional_data = additional_data
          cellphone_deal_attribute_new.rollover_data = rollover_data
          cellphone_deal_attribute_new.save
        end
      end
    end
  end

  task update_deal_equipments_set_deal_id: :environment do
    deals = Deal.all
    deals.each do |deal|
      category_name = ServiceCategory.where(:id => deal.service_category_id).pluck(:name).first.downcase
      attributes = eval("#{category_name.camelcase}DealAttribute").where(:deal_id => deal.id)
      attributes.each do |attribute|
        equipments = eval("#{category_name.camelcase}Equipment").where("#{category_name}_deal_attribute_id".to_sym => attribute.id)
        puts "--------------#{deal.id}------#{attribute.id}------"
        equipments.update_all(:deal_id => deal.id)
      end
    end
  end

#task to map city and states
  task map_state_and_city: :environment do
    state_list=["TX", "NY", "OH", "NE", "SC", "CA", "PA", "NM", "NJ", "NC", "MO", "KS", "WI", "MI", "VA", "AL", "HI", "MA", "CO", "ID", "WA", "TN", "AZ", "ME", "NH", "IN", "KY", "WV", "IL", "VT", "FL", "RI", "CT", "DE", "DC", "MD", "GA", "AA", "MS", "IA", "MN", "SD", "ND", "MT", "LA", "AR", "OK", "WY", "UT", "NV", "AP", "GU", "PW ", "FM", "MP ", "MH ", "OR", "AK"]
    state_list.each do | state |
      puts "Mapping for "+state.downcase
      begin
        api_datas=JSON.parse(URI.parse("http://api.sba.gov/geodata/city_links_for_state_of/"+state+".json").read)
        api_datas.each do |api_data|
          city=api_data["name"]
          state=api_data["state_abbreviation"]
          county=api_data["county_name"]
          Statelist.create!(:state=>state, :city=>city, :county=>county)
          puts "Cities mapped for "+state
        end
      rescue
        puts "bad request for "+state.downcase
      end
    end

  end
  task encrypt_app_user_data: :environment do
    obj=ApplicationController.new
    @user=AppUser.all

    @user.each do |user_data|
      fname=user_data.first_name
      lname=user_data.last_name
      zip=user_data.zip
      if fname.present?
        puts "first name=#{fname}"
        fname=obj.encode_api_data(fname)
        puts "Encoded first name=#{fname}"
      end
      if lname.present?
        lname=obj.encode_api_data(lname)
        puts "last name=#{lname}"
      end
      if zip.present?
        zip=obj.encode_api_data(zip)
        puts "zip=#{zip}"
      end
      user_data.update_attributes(:first_name=>fname, :last_name=>lname, :zip=>zip)
      puts "----------------------------------------"
    end
    puts "==========================================="
    puts "updated AppUser Table"
    puts "==========================================="
  end

  task encrypt_business_data: :environment do
    obj=ApplicationController.new
    @business_data=Business.all
    @business_data.each do |business|
      business.update_attributes(:federal_number=>obj.encode_api_data(business.federal_number)) if business.federal_number.present?
      business.update_attributes(:ssn=>obj.encode_api_data(business.ssn)) if business.ssn.present?
      puts "business_id=#{business.id}"
      puts "federal_number= #{business.federal_number}"
      puts "ssn=#{business.ssn}"
      puts "updated"
    end
  end
  task encrypt_business_name: :environment do
    obj=ApplicationController.new
    @business_data=Business.all
    @business_data.each do |business|
      business.update_attributes(:business_name=>obj.encode_api_data(business.business_name)) if business.business_name.present?
      puts "updated#{business.id}"
    end
  end
  task verify_all_users: :environment do
    allusers=AppUser.find_by_email_verified(false)
    if allusers.present?
      puts "Verifying Unverified Users"
      allusers.each do |user|
        puts "============================================="
        puts "verifying #{Base64.decode64(user.first_name)}"
        user.update_attributes(:email_verified => true)
        puts "#{Base64.decode64(user.first_name)} Verified"
        puts "============================================="
      end
    else
      puts "All users Verified"
    end
  end

  task populate_equipment_colors: :environment do
    EquipmentColor.create(:color_name => 'Black',:status=> true,:created_at => Time.now,:updated_at => Time.now,:color_code => '#000000')
    EquipmentColor.create(:color_name => 'White',:status=> true,:created_at => Time.now,:updated_at => Time.now,:color_code => '#FFFFFF')
    EquipmentColor.create(:color_name => 'Silver',:status=> true,:created_at => Time.now,:updated_at => Time.now,:color_code => '#D3D3D3')
    EquipmentColor.create(:color_name => 'Rose Gold',:status=> true,:created_at => Time.now,:updated_at => Time.now,:color_code => '#B76E79')
  end
end
