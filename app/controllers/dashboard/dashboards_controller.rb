class Dashboard::DashboardsController < ApplicationController
  def index
    redirect_to login_admin_admins_path and return unless session[:id].present?
  end


  def populate_graph_ajaxified

  end

  def list_orders_ajaxified
    @order_requests = []
    @pending_orders = []
    @completed_orders = []
  end

  def list_signups_ajaxified
    @orders = []
    @user_registered = AppUser.order("created_at desc").limit(50)
  end

end
