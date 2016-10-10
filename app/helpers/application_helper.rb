module ApplicationHelper

  ## used for form_tag or simple forms to show errors
  def dpl_err_msg(obj,field, display_name = nil)
    "<span style='color: #ED5565;'>#{display_name} #{obj.errors[field].to_sentence}</span>".html_safe if obj.present? and obj.errors[field].present?
  end

  def dpl_err_cls(obj,field)
    "has-error" if obj.present? and obj.errors[field].present?
  end

  ## used for form_for method to show errors
  class ActionView::Helpers::FormBuilder

    def dpl_err_msg(field, display_name = nil)
      "<span style='color: #ED5565;'>#{display_name} #{self.object.errors[field].to_sentence}</span>".html_safe if self.object.errors[field].present?
    end

    def dpl_err_cls(field)
      "has-error" if self.object.errors[field].present?
    end

  end


  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end

  def get_statuses
    {'Enable' => ACTIVE_STATUS,'Disabled' => DEACTIVE_STATUS,'Pending' => PENDING_STATUS}
  end

  def get_public_status
    {'YES' => "true",'NO' => "false"}
  end

  def get_status_css(status_code)
    if status_code == ACTIVE_STATUS
      'label-primary'
    elsif status_code == DEACTIVE_STATUS
      'label-danger'
    elsif status_code == PENDING_STATUS
      'label-warning'
    end
  end

  def get_pending_actions(limit)
    PendingAction.get_pending_actions(session[:id],limit)
  end

  def get_pending_actions_count
    PendingAction.get_pending_actions_count(session[:id])
  end

  def get_pending_action_details(action_type,key)
    case action_type
      when PendingAction::CAMPAIGN_PENDING
        message = 'Campaign Pending for Approval'
        url = edit_admin_pending_action_path(key)
        return message,url
      when PendingAction::FEEDBACK_PENDING
        message = 'Feedback Pending for Approval'
        url = edit_admin_pending_action_path(key)
        return message,url
    end
  end

  def get_service_providers
    provider_hash = {}
    providers = ServiceProvider.all
    providers.each do |provider|
      provider_hash[provider.name] = provider.id
    end
    provider_hash
  end

  def get_cities(response_type = 'array')
    if response_type == 'array'
      City.get_cities
    else
      city_hash = {}
      cities = City.all.order("seo_city ASC")
      cities.each do |tc|
        city_hash[tc.city_name] = tc.seo_city
      end
      city_hash
    end
  end

  def get_city_and_location_details(city_id,location_id)
    if city_id.present? and location_id.present?
      City.find_by_sql("select city_name,city_state,city_country,location,zip from city_locations
                       inner join cities c on c.id = city_locations.city_id
                       where c.seo_city = '#{city_id}'and city_locations.seo_location = '#{location_id}'").first
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == params[:sort] ? "current #{sort_direction}" : nil
    if column == 'created_at' && params[:sort].blank?
      css_class = "current desc"
    end
    direction = sort_direction == "asc" ? "desc" : "asc"
    link_to(title, params.merge({:sort => column, :direction => direction}), {:class => css_class})
  end

  def display_provider_logo(sp)
    random_no = rand(1..4)
    if sp.present?
      lab_info = ServiceProvider.find(sp.id)
      if sp.logo_file_name.present?
        image_tag sp.logo.url(:medium)
      else
        image_tag("default-lab-images/diagnostic-center-#{random_no}.jpg",:style => "width: 400px;height: 180px;margin-top: -80px;")
      end
    else
      if lab_info.logo_file_name.present?
        image_tag lab_info.logo.url(:medium)
      else
        image_tag("default-lab-images/diagnostic-center-#{random_no}.jpg",:style => "width: 400px;height: 180px;margin-top: -80px;")
      end
    end
  end

  def get_zip(seo_location)
    CityLocation.where("seo_location = ?", seo_location).first.zip
  end

  def show_price price
    "&#8377;&nbsp;#{price}".html_safe
  end

  def fetch_user_address
    address_hash = {}
    addresses = AppUserAddress.fetch_user_address(current_user)
    addresses.each do |addr|
      address_hash["#{addr.address1} #{addr.landmark}"] = addr.id
    end
    address_hash
  end
end