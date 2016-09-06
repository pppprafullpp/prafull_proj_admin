class User::SessionsController < ApplicationController
  layout "empty"
  require 'net/http'
  def create
    @user_social_login_detail,@email,@fb_image = UserSocialLoginDetail.from_omniauth(env["omniauth.auth"])
    @user = User.find_by_id(@user_social_login_detail.user_id)
    if @user.present?
      session[:id] = @user.id
      session[:role] = USER
      session[:user_name] = @user_social_login_detail.name
      session[:fb_image] = @fb_image
      redirect_to root_path
    end
  end

  def create_dpl_user_by_fb
    user = User.find_by_email(params[:email])
    if user.present?
      user.update_attributes(:mobile => params[:mobile])
    else
      user = User.create_user(user_params)
    end

    user_social_login_detail = UserSocialLoginDetail.find_by_id(params[:social_login_id])
    user_social_login_detail.update_attributes(:user_id => user.id) if user_social_login_detail.present?
    if user.present?
      session[:id] = user.id
      session[:role] = USER
      session[:user_name] = user_social_login_detail.name
      session[:fb_image] = params[:fb_image]
      redirect_to root_path
    end
  end

  private
  def user_params
    params.permit(:first_name, :email, :mobile, :social_login_id,:fb_image)
  end
end
