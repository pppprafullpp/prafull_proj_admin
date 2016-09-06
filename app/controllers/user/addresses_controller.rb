class User::AddressesController < User::UserApplicationController
  before_filter :set_search

  def index
    if is_admin?
      @addresses = UserAddress.all
    else   
      @addresses = UserAddress.where(:user_id => session[:id])
    end  
  end

  def search
    params[:search] = {} unless params[:search].present?
    @addresses = UserAddress.search(params[:search])
    render 'user/addresses/index'
  end

  def new
    if session[:role] == USER
      @address = UserAddress.new
    else
      redirect_to root_url
    end
  end

  def create
    @address = UserAddress.new(user_address_param)
    if @address.save
      flash[:notice] = 'address have been created successfully.'
      redirect_to user_addresses_path
    else
      render new_user_address_path
    end
  end

  def edit
    @address = UserAddress.where(:id => params[:id],:user_id => session[:id]).first
  end

  def update
    @address = UserAddress.find(params[:id])
    if @address.update_attributes(user_address_param)
      flash[:notice] = 'address have been updated successfully.'
      redirect_to user_addresses_path
    else
      render 'user/addresses/edit'
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_address_param
    params.require(:user_address).permit(:user_id,:nickname,:address1, :address2,:contact_number,:city_id,:city_location_id,:landmark,:status)
  end

  def set_search
    @search = UserAddress.new
  end
end
