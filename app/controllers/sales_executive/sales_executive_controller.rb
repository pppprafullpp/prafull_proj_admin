class SalesExecutive::SalesExecutiveController <  SalesExecutive::SalesExecutiveApplicationController

  def index
      params[:search] = {} unless params[:search].present?
      @search = SalesExecutive.new
      @breadcrumb = {'Home' => home_url, 'Sales Executive' => ''}
      @sales_excecutives = SalesExecutive.search(params[:search]).order("id DESC")
      @sales_excecutives =  @sales_excecutives.paginate(:page => params[:page], :per_page => PER_PAGE)
      @new_sales_executive = SalesExecutive.new
  end

  def create
    # raise params.to_yaml
    if params[:sales_executive][:id].present?
      SalesExecutive.find(params[:sales_executive][:id]).update_attributes(:name=>params[:sales_executive][:name],:email => params[:sales_executive][:email])
    else
      new_profile = SalesExecutive.create_profile(params[:sales_executive])
      # notify(new_profile ,SalesExecutive,WELCOME_NOTIFICATION,true,{:email => true,:password => new_profile.encrypted_password})   # showing error
    end

    redirect_to sales_executive_sales_executive_index_path
  end

  def update_enabled_status
    sales_executive = SalesExecutive.find(params[:id]).update_attributes(:enabled => params[:status])
    render :json => {
      "updated":true
    }
  end

  def reset_password
    sales_executive = SalesExecutive.find(params[:id])
    new_password = SalesExecutive.encrypt(SalesExecutive.generate_random_password)
    sales_executive.encrypted_password = new_password
    sales_executive.save
    notify(sales_executive ,"SalesExecutive","reset_sales_executive_password",false,{:email => true,:password => new_password, :reset_password => true}) and return # showing error
    render :json => {
      "updated":true
    }
    notify(sales_executive ,SalesExecutive,"reset_sales_executive_password",true,{:email => true,:password => sales_executive.encrypted_password})   # showing error
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
