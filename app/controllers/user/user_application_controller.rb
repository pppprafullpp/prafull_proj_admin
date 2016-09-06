class User::UserApplicationController < ApplicationController

  before_filter :check_user_access, :except => [:login, :new, :create, :forgot_password, :reset_password,:fetch_user_details]

  def check_user_access
    if params[:controller] != "user/reports" and params[:action] != "index"
      redirect_to root_url unless is_admin? || is_sales_executive?
    end
  end

end
