class SalesExecutive::SalesExecutiveController < ApplicationController

  layout "empty", :only => [:login]
  before_action :check_login, :except => [:login]

  def check_login
    # raise "check"
    if !current_user.present?
      flash[:danger] = "You need to login first"
      redirect_to login_sales_executive_sales_executive_index_path
    end
  end

  def login
     if request.method.eql? 'POST'
        sales_executive_info = SalesExecutive.authenticate(params[:email], params[:password]).first
          flash[:danger] = "Your Profile has been Deactivated"
          session[:referer_url] = request.referer
          if sales_executive_info.present?
            # raise "chk"
            # if sales_executive_info.enabled
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
        # else
        #   flash['error'] = 'Incorrect Username or Password!'
        #   redirect_to login_sales_executive_sales_executive_index_path
        # end
     end
  end

  def logout
    reset_session
    redirect_to root_url and return
  end

  def index
    if session[:role] == ADMIN
      params[:search] = {} unless params[:search].present?
      @search = SalesExecutive.new
      @breadcrumb = {'Home' => home_url, 'Sales Executive' => ''}
      @sales_excecutives = SalesExecutive.search(params[:search])
      @sales_excecutives =  @sales_excecutives.paginate(:page => params[:page], :per_page => PER_PAGE)
    else
      redirect_to login_admin_admins_path
    end
  end

  def new
      @new_sales_executive = SalesExecutive.new
      @breadcrumb = {'Home' => home_url, 'Sales Executive' => sales_executive_sales_executive_index_path, 'Create Sales Executive profile' => ''}
  end

  def create
    name = params[:sales_executive][:name]
    email = params[:sales_executive][:email]
    enabled = params[:sales_executive][:enabled]
    sales_executive = SalesExecutive.find_or_initialize_by(:name => name,:email => email)
    sales_executive.encrypted_password = SalesExecutive.encrypt("123456")
    sales_executive.role = SalesExecutive::SALES_EXECUTIVE
    sales_executive.enabled = enabled
    sales_executive.save
    Admin::AdminMailer.create_sales_executive_profile(sales_executive.id,"123456")
    flash[:success] = "Created , password mailed to #{name}"
    redirect_to sales_executive_sales_executive_index_path
  end

  def update_enabled_status
    sales_executtive = SalesExecutive.find(params[:id]).update_attributes(:enabled => params[:status])
    render :json => {
      "updated":true
    }
  end

  def reset_password
    sales_executive = SalesExecutive.find(params[:id])
    sales_executive.encrypted_password = SalesExecutive.encrypt("111111")
    sales_executive.save
    Admin::AdminMailer.reset_sales_executive_password(sales_executive.id,"111111")
    render :json => {
      "updated":true
    }
  end

  def show_personal_details
    @details = SalesExecutive.find(session[:id])
    @breadcrumb = {'Home' => home_url, 'Profile' => ''}
  end

  def update
    sales_executive = SalesExecutive.find(params[:id]).update_attributes(:name =>params[:sales_executive][:name], :email => params[:sales_executive][:email])
    flash[:success] = "updated"
    redirect_to :back
  end
end

private

  def sales_excecutive_params
    params.require(:sales_excecutive).permit!
  end
