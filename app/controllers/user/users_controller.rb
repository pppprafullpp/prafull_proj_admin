class User::UsersController < User::UserApplicationController

  before_filter :set_layout,:set_search

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
    @user = User.new
  end

  def create
    @user = User.new(user_param)
    name = params[:user][:first_name].split(' ')
    first_name = name[0]
    last_name = name[1..4].join(' ')
    prefix = params[:user][:prefix].present? ? params[:user][:prefix] : User::MR
    @user.first_name = first_name ; @user.last_name = last_name ; @user.prefix = prefix
    if @user.save
      @user.password = params[:user][:password]
      notify(@user,USER,WELCOME_NOTIFICATION,true,{:email => true,:password => params[:user][:password]})
      flash[:notice] = 'User details have been created successfully.'
      if session[:cart].present?
        redirect_to checkout_path and return
      else
        redirect_to user_login_path
      end
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
     
    if @user.update_attributes(user_param)
      flash[:notice] = 'User details have been updated successfully.'
      redirect_to user_users_path
    else
      render 'user/users/edit'
    end
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

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_param
    params.require(:user).permit(:password, :confirm_password, :first_name, :last_name,:age,:prefix,:email,:mobile,:landline,:emergency_contact_number,:upload, :upload_file_name, :upload_content_type, :upload_file_size)
  end

  def set_layout
    self.class.layout(session[:id].blank? ? 'empty' : 'application')
  end

  def set_search
    @search = AppUser.new
  end
end
