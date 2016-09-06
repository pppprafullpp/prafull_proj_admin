class User::UserMailer < ApplicationMailer

  def welcome_email(user,password = '')
    #user = User.find(user) if user.class.to_s == 'Fixnum'
    @user = user
    @password = password
    @url  = 'http://www.servicedeals.com'
    mail(to: @user.email,bcc: APP_CONFIG[:contact_email] ,subject: 'Welcome to Service Deals')
  end
  
  def forgot_password_email(user, token)
    #user = User.find(user) if user.class.to_s == 'Fixnum'
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Service Deals:Reset Password')
  end

  def generate_otp_email(user)
    @user = user
    mail(to: @user.email, subject: 'Service Deals:OTP')
  end

end
