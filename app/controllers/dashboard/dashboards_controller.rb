class Dashboard::DashboardsController < ApplicationController
  def index
    redirect_to login_admin_admins_path and return unless session[:id].present?
    @user_count=AppUser.count
    @order_count=Order.count
  end


  def populate_graph_ajaxified

  end

  def list_orders_ajaxified
    @order_requests = Order.where(:status => "New Order").order("ID DESC")
    @pending_orders = Order.where(:status => "In-progress").order("ID DESC")
    @completed_orders = Order.where(:status => "completed").order("ID DESC")

    respond_to do |format|
      format.js
      format.html
    end
  end

  def list_signups_ajaxified
    @orders = Order.all.order("Id DESC")
    @user_registered = AppUser.order("created_at desc").limit(50)
    respond_to do |format|
      format.js
      format.html
    end
  end



  def get_service_providers
    #@ServiceProviders=ServiceProvider.select("id, name").where(service_category_name: params[:category])
    @ServiceProviders = ServiceProvider.select("id, name").where(service_category_id: params[:category])
    render :json => @ServiceProviders
  end


end
