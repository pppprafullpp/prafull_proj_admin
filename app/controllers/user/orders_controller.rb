class User::OrdersController < User::UserApplicationController
  before_filter :set_search

  def index
    params[:search] = {} unless params[:search].present?
    @breadcrumb = {'Home' =>"/user/orders", 'Orders' => ''}
    @orders = Order.search(params[:search]).order("ID DESC")
    @orders = @orders.paginate(:page => params[:page], :per_page => PER_PAGE)
    @search = Order.new
  end

  def new
    @order = Order.new
  end

  def create
    user_type = params[:app_user][:user_type].present? ? params[:app_user][:user_type] : nil
    if [AppUser::RESIDENCE,AppUser::BUSINESS].include?(user_type)
      order = Order.new(order_params)
      order.order_id=rand(36**8).to_s(36).upcase
      if order.save
        order_attribute_hash = {:order_items => [params[:order_items]]}
        order_items = OrderItem.create_order_items(order_attribute_hash,order.id)
        # if  order_items.first.deal.is_customisable == true
          # order_equipment = OrderEquipment.create_order_equipments(params,order.id)
        #   order_extra_services = OrderExtraService.create_order_extra_services(params,order.id)
        # end
        app_user_params = encoding_data(params)
        app_user_hash = {:app_user => app_user_params }
        app_user = AppUser.update_app_user(app_user_hash,order.app_user_id,order)
        address_hash = {:business_addresses => [params[:shipping_addresses],params[:billing_addresses],params[:service_addresses]] }  if params[:app_user][:user_type] == "business"
        address_hash = {:app_user_addresses => [params[:shipping_addresses],params[:billing_addresses],params[:service_addresses]] }  if params[:app_user][:user_type] == "residence"

        order_addresses = OrderAddress.create_order_addresses(address_hash,order.id)
        if user_type == AppUser::BUSINESS
          business = Business.create_business(params)
          if business.present?
            business_addresses = BusinessAddress.create_business_addresses(address_hash,business.id)
            business_user = BusinessAppUser.create_business_app_user(business.id,app_user.id)
          end
          # OrderMailer.delay.order_confirmation(app_user,order)
        else
          app_user_addresses = AppUserAddress.create_app_user_addresses(address_hash,app_user.id)
          # OrderMailer.delay.order_confirmation(app_user,order)
        end
      end
      redirect_to user_orders_path
    end


  end

  def edit
    @order = Order.find(params[:id])
  end

  def update

  end

  def destroy
    # Order.find(params[:id]).update_attributes(:status => "Cancelled")
    flash[:success] = "Cancelled"
    redirect_to :back
  end

  def deal_details
    @deal = Deal.find(params[:deal_id])
    if @deal.is_customisable == true && @deal.service_category_id == Deal::CELLPHONE_CATEGORY
      @deal = @deal.as_json(:include =>{:deal_equipments =>{:except=>[:available_colors],:methods => [:available_color,:cellphone_name,:brand,:description]},:deal_extra_services => {:methods => [:service_name,:service_description]} },:except => [:created_at, :updated_at, :image, :price],:methods => [:deal_price,:service_category_name, :service_provider_name,:deal_attributes])
    elsif  @deal.is_customisable == true && @deal.service_category_id == Deal::CABLE_CATEGORY
      @deal =  @deal.as_json(:include =>{:channel_packages => {:methods=>[:channel_name]},:deal_attributes => {:methods => [:channel_name]},:deal_extra_services => {:methods => [:service_name,:service_description]}},:except => [:created_at, :updated_at, :image, :price],:methods => [:deal_price,:service_category_name, :service_provider_name,:deal_equipments])
    else
      @deal = @deal.as_json(:except => [:created_at, :updated_at, :image, :price],:methods => [ :deal_price,:service_category_name, :service_provider_name,:deal_equipments,:deal_attributes])
    end
  end

  private

  def set_search

  end

  def user_param
    params.require(:order).permit!
  end
  def order_params
    params.require(:order).permit(:id,:order_id,:deal_id,:app_user_id,:status,:deal_price,:effective_price,:activation_date,:order_type,:primary_id,:secondary_id,:is_shipping_address_same,:primary_id_number,:secondary_id_number)
  end
end
