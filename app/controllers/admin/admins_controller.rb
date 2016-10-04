class Admin::AdminsController < Admin::AdminApplicationController

  layout "empty"

  def login
     if request.method.eql? 'POST'
        admin_info = Admin.authenticate(params[:email], params[:password]).first
        session[:referer_url] = request.referer
        if admin_info.present?
          if admin_info.present?
            LoginDetail.track_login(admin_info)
            init_servicedeals_session(admin_info)
            if params[:referer].present?
              redirect_to session[:referer_url] and return
            else
              redirect_to dashboard_dashboards_path and return
            end
          end
        else
          flash['error'] = 'Incorrect Username or Password!'
          redirect_to login_admin_admins_url and return
        end
     end
  end

  def logout
    reset_session
    redirect_to root_url and return
  end

end
