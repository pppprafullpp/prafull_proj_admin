class HomeController < ApplicationController
  #layout "home"
  before_filter :set_layout

  def index
    @package_count = 0
    @top_packages = []
  end

  def minor
  
  end

  
  def contact
    if request.method.eql? 'POST'
      Admin::AdminMailer.delay.contact_us(params[:name],params[:email], params[:phone], params[:message])
      flash[:notice] = "Thanks for contacting us. Our Team member will reach to you soon."
    end
  end


  def create_feedback
    redirect_to login_user_users_path and return if session[:role] != USER
    @feedback = Feedback.new(feedback_params)
    @feedback.user_id = session[:id]
    if @feedback.save
      PendingAction.create_pending_action(session[:id],Admin::ADMIN_ID,PendingAction::FEEDBACK_PENDING,@feedback.id)
      flash[:notice] = 'Thank You ! for your valuable feedback. keep visiting Service Deals.'
      render :feedback
    else
      flash[:warning] = 'Sorry for the inconvenience, we are down at this time.'
      render :feedback
    end
  end

  def change_password
    if session[:role].present? and [ADMIN,SALES_EXECUTIVE].include?(session[:role].capitalize)
    else
      redirect_to root_url
    end
  end

  def update_password
    if session[:id].present? and session[:role].present? and [ADMIN,SALES_EXECUTIVE].include?(session[:role].capitalize)
      obj = eval(session[:role]).find(session[:id])
      old_password = Admin.encrypt(params[:old_password])
      if old_password.to_s == obj.password.to_s
        new_password = Admin.encrypt(params[:new_password])
        new_confirm_password = Admin.encrypt(params[:confirm_password])
        if new_password == new_confirm_password
          obj.password = new_password
          obj.save
          flash[:notice] = 'Your Password updated successfully'
        else
          flash[:warning] = 'Your Password/Confirm Password didnot match.'
        end
      else
        flash[:warning] = 'Your old Password did not match.'
      end
      render 'home/change_password'
    else
      flash[:warning] = 'Please login to update your password.'
      redirect_to root_url
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.

  def feedback_params
    params.require(:feedbacks).permit(:feedback)
  end

  def set_layout
    
    if([ 'contact','team','download_report','privacy_policy','faq','about_us', 'checkout'].include?(params[:action]))
       self.class.layout 'empty'   
    elsif(['change_password', 'update_password'].include?(params[:action]))
      self.class.layout 'application'
    else
      self.class.layout 'home'
    end      
      

    flash[:notice] = nil
    flash[:warning] = nil
  end
end
