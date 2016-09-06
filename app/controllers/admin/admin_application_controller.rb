class Admin::AdminApplicationController < ApplicationController
 
 before_filter :check_admin_access, :except => [:login, :log_out_url] 
 
 def check_admin_access
   redirect_to root_url unless is_admin? 
 end
 
end
