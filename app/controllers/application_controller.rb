class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :is_admin?, :is_sales_executive?,:current_user, :auth_display_name, :auth_display_pic,:current_controller, :sort_direction,:decode_api_data

  ## modules ##
  include Notify


  def init_servicedeals_session(auth_details)
    session[:id] = auth_details.id
    session[:role] = auth_details.class.to_s
    session[:user_name] = auth_details.name
  end

  def current_user
    session[:id].present? ?  eval(session[:role]).find(session[:id]) : []
  end

  def is_admin?
    session[:id].present? && session[:role].eql?(ADMIN)
  end

  def is_sales_executive?
    session[:id].present? && session[:role].eql?(SALES_EXECUTIVE)
  end

  def auth_display_name
    if is_admin?
      current_user.name
    elsif is_sales_executive?
      current_user.contact_name
    end
  end

  def auth_display_pic(size)
    current_user.upload.url(size.to_sym) if current_user.upload.present?
  end

  def generate_random_password
    User.generate_random_password
  end

  def logout
    role = session[:role]
    case role
      when ADMIN
        redirect_url = login_admin_admins_path
      when SALES_EXECUTIVE
        redirect_url = login_admin_admins_path
      else
        redirect_url = login_admin_admins_path
    end

    reset_session
    flash[:notice] = 'You have been log out successfully.'
    redirect_to redirect_url and return
  end

  def log_out_url
    if is_admin?

    elsif is_sales_executive?

    end
  end

  def current_controller
    params[:controller]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def home_url
    home_index_path
  end

  def decode_api_data(data)
    if data.present?
      return Base64.decode64(data)
    else
      ''
    end
  end

  def encode_api_data(data)
    return Base64.encode64(data)
  end

  def encoding_data(params)
    if params[:app_user].present?
      record = {}
      params[:app_user].each do |key,value|
        if(key == 'first_name' || key == 'last_name' || key == 'mobile')
          record[key] = encode_api_data(value)
        else
          record[key] = value
        end
      end
      record
    end
  end

  def encode_search_filter_data
    if params[:search].present?
      params[:search][:first_name] = encode_api_data(params[:search][:first_name]) if params[:search][:first_name].present?
      params[:search][:last_name] = encode_api_data(params[:search][:last_name]) if params[:search][:last_name].present?
      #params[:search][:email] = encode_api_data(params[:search][:email]) if params[:search][:email].present?
    end
    params
  end

  private
  #Set headers for cross-domain request
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

  def api_access
    if ApiToken.token_valid?(params[:token], params[:dev_uuid])
      token = ApiToken.find_by_token(params[:token])
      token.touch
      ApiTokenDetail.create(:api_token_id => token.id, :api => params["action"])
      user = User.find_by_user_id(token.username)
      session[:username] = user.user_id
      session[:userid] = user.id
      session[:firstname] = user.full_name
    else
      ApiToken.where(:token => params[:token]).destroy_all

      respond_to do |format|
        set_access_control_headers
        format.js {render :js => {:error => 1, :message => "Token is invalid/expired"}.to_json and return}
      end
    end
  end
end
