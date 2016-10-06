class SalesExecutive::SalesExecutiveApplicationController < ApplicationController

  before_filter :check_access, :except => [:login, :log_out_url]
  layout "empty", :only => [:login]

  def check_access
    unless is_admin? or is_sales_executive?
      redirect_to root_url
    end
  end

  def login
  if request.method.eql? 'POST'
    sales_executive_info = SalesExecutive.authenticate(params[:email], params[:password]).first
      session[:referer_url] = request.referer
      if sales_executive_info.present?
          LoginDetail.track_login(sales_executive_info)
          init_servicedeals_session(sales_executive_info)
          if params[:referer].present?
            redirect_to session[:referer_url] and return
          else
            redirect_to dashboard_dashboards_path and return
          end
        else
          flash['error'] = 'Incorrect Username or Password!'
          redirect_to login_sales_executive_sales_executive_index_path and return
        end
      end
  end

    def logout
      reset_session
      redirect_to root_url and return
    end


end
