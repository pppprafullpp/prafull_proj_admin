class User::UsersController < User::UserApplicationController

  before_filter :set_layout,:set_search,:encode_search_filter_data

  def index
    params[:search] = {} unless params[:search].present?

    @breadcrumb = {'Home' => home_url, 'Profile' => ''}
    @users = AppUser.search(params[:search])

    if params[:sort].present?
      dir = (params[:direction].eql?('asc')) ? params[:direction] : 'desc'
      @users = @users.order("#{ params[:sort]} #{dir}")
    else
      @users = @users.order("created_at DESC")
    end

    @users = @users.paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  def new
    @user = AppUser.new
  end

  def create
    app_user = encoding_data(params)
    user_hash = {:app_user => [app_user]}
    @user = AppUser.create_new_user(user_hash)
    @user.first.zip = Base64.encode64("75209")
    @user.first.save
      # notify(@user,USER,WELCOME_NOTIFICATION,true,{:email => true,:password => params[:user][:password]})
    flash[:notice] = 'User details have been created successfully.'
    redirect_to user_users_path
  end

  def edit
    @user = AppUser.find(params[:id])
    @business = Business.select('businesses.*').joins(:business_app_users).where("business_app_users.app_user_id = ?",@user.id).last

  end

  def update
    app_user = encoding_data(params)
    user_hash = {:app_user => app_user}
    @user = AppUser.update_app_user(user_hash,params[:user][:id],order=nil)
    # @user = AppUser.create_new_user(user_hash)
    if @user.user_type == AppUser::BUSINESS
      params[:business][:federal_number]=encode_api_data(params[:business][:federal_number]) if params[:business][:federal_number].present?
      params[:business][:ssn]=encode_api_data(params[:business][:ssn]) if params[:business][:ssn].present?
      params[:business][:business_name]=encode_api_data(params[:business][:business_name]) if params[:business][:business_name].present?
      @business = Business.create_business(params)
      if @business.present?
        address_hash = {:business_addresses => [params[:addresses]]}
        business_user = BusinessAppUser.create_business_app_user(@business.id,@user.id)
        business_addresses = BusinessAddress.create_business_addresses(address_hash,@business.id)
      end
    else
        address_hash = {:app_user_addresses => [params[:addresses]]}
        app_user_addresses = AppUserAddress.create_app_user_addresses(address_hash,@user.id)
    end
    redirect_to user_users_path
  end


  def app_user_type
    # users = AppUser.select('id,first_name').where(user_type: params[:user_type]).limit(10)
    users = AppUser.select('id,first_name').where(user_type: params[:user_type]).order("created_at DESC").limit(10)
    render :json=>{
        :status=>users
      }
  end

  def app_user_deals
    zipcode = decode_api_data(AppUser.find_by_id(params[:id]).zip)
    deals = Deal.joins(:deals_zipcodes).joins(:zipcodes).select("deals.id,deals.title").where("zipcodes.code= ? AND deal_type =? AND is_active = ? ",zipcode,params[:user_type],true)
    render :json=>{
        :status=>deals
      }
  end

  def business_information
    if params[:id].present?
      app_user = AppUser.find_by_id(params[:id])
      business = app_user.business_app_users.last.business
      render :json=>{
        :status=>business
      }
    end
  end


  def addresses
    if params[:id].present?
      @addresses = AppUser.get_addresses(params)
      render :json=>{
        :status=>"business_user_first_order",
        :status=>@addresses
      }
    end
  end

  def personal_details
    app_user = AppUser.find(params[:id])
     render :json=>{
        :status=>app_user
      }
  end

  def fetch_user_details
    mobile = params[:mobile]
    user = User.where(:mobile => mobile) if mobile.present?
    respond_to do |format|
      format.html {render :nothing => true }
      format.js { render :json => { :data => user, :layout => false}.to_json}
    end
  end

  def login
    if request.method.eql? 'POST'
      user_info = User.authenticate(params[:email], params[:password])

      if user_info.present?
        if user_info.status == ACTIVE_STATUS
          LoginDetail.track_login(user_info)
          session[:id] = user_info.id
          session[:role] = USER
          session[:user_name] = "#{user_info.first_name} #{user_info.last_name}"
          session[:referer_url] = request.referer unless session[:referer_url].present?
          if session[:cart].present?
            redirect_to checkout_path and return
          elsif session[:doctor_appointment].present?
            redirect_to book_appointment_appointments_path and return
          elsif params[:referer].present?
            redirect_to session[:referer_url] and return
          else
            redirect_to root_url and return
          end
        else
          flash['warning'] = 'Account is not Active. Please contact Service Deals administrator.'
          redirect_to user_login_url and return
        end
      else
        flash['warning'] = 'Incorrect Username or Password!'
        redirect_to user_login_url and return
      end
    else
      redirect_to root_url if session[:id].present?
    end
  end

  def forgot_password
    if request.method.eql? 'POST'
      if params[:email].present?
        @user = User.where("email = ? AND status = ?", params[:email], ACTIVE_STATUS).first

        if @user.present?
          @user.token = AutoToken.generate_token

          auto_token = AutoToken.new
          auto_token.tokenable = @user
          auto_token.token = @user.token
          auto_token.status = ACTIVE_STATUS
          auto_token.save

          notify(@user,USER,FORGOT_PASSWORD_NOTIFICATION, false,{:email => true, :password => @user.token})

          flash['notice'] = 'Email has been sent on your registered email address.'

        else
          flash['warning'] = 'Email does not exist.'
        end
      else
        flash['warning'] = 'Email should not be blank.'
      end
    end
  end


  def reset_password
    if request.method.eql? 'POST'
      token_details = AutoToken.validate_token('User', params[:id])
      if token_details.present?
        if params[:password] == params[:confirm_password]
          user = token_details.tokenable
          if user.update_attributes({:password => Admin.encrypt(params[:password])})
            token_details.update_attributes({:status => DEACTIVE_STATUS})
            flash[:notice] = 'Password has been changed successfully.'
            redirect_to login_user_users_path and return
          else
            flash[:warning] = user.errors.full_messages.join('</br>')
            redirect_to login_user_users_path and return
          end
        else
          flash[:warning] = 'Password and Confirm Password must be same'
          redirect_to reset_password_user_user_path(params[:id]) and return
        end
      else
        flash[:warning] = 'Link is not valid'
        redirect_to forgot_password_user_users_path and return
      end
    else
      unless AutoToken.validate_token('User', params[:id]).present?
        flash[:warning] = 'Link is not valid'
        redirect_to forgot_password_user_users_path and return
      end
    end
  end

  def create_deals
    
  end

  private


  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_param
    params.require(:user).permit!
  #   params.require(:user).permit(:password, :confirm_password, :first_name, :last_name,:age,:prefix,:email,:mobile,:landline,:emergency_contact_number,:upload, :upload_file_name, :upload_content_type, :upload_file_size)
  end

  def set_layout
    self.class.layout(session[:id].blank? ? 'empty' : 'application')
  end

  def set_search
    @search = AppUser.new
  end
end
