class SalesExecutive::SalesExecutiveApplicationController < ApplicationController

  before_filter :check_access, :except => [:login, :log_out_url]
  layout "empty", :only => [:login]

  def check_access
    unless is_admin? or is_sales_executive?
      redirect_to root_url
    end
  end

  def logout
    reset_session
    redirect_to root_url and return
  end


end
