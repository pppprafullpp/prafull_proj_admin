class Admin::AdminMailer < ApplicationMailer
  ADMIN_EMAIL = ['amit.pandey@spa-systems.com']

  def welcome_email(admin,password = '')
    @admin = admin
    @password = password
    @url  = 'http://www.servicedeals.com'
    mail(to: @admin.email,bcc: APP_CONFIG[:contact_email], subject: 'Welcome to My Awesome Site')
  end

  def exception_mail(message,exp)
    @message = message;@exp = exp
    mail(to: ADMIN_EMAIL.join(','), subject: 'SMS Exception')
  end


  def contact_us(name,email,mobile, message)
    @name = name
    @email = email
    @mobile = mobile
    @message = message

    mail(to: APP_CONFIG[:contact_email],cc: ADMIN_EMAIL.join(','), subject: "Service Deals:New Message Received")
  end
  def reset_sales_executive_password(id,new_password)
    @name = SalesExecutive.find(id).name
    email = SalesExecutive.find(id).email
    @new_password = new_password
    mail(to:email,subject:"Password reset on Service Dealz Sales Portal").deliver!
  end

  def create_sales_executive_profile(id,decrypted_password)
    @name = SalesExecutive.find(id).name
    @email = SalesExecutive.find(id).email
    @decrypted_password = decrypted_password
    mail(to:@email,subject:"Welcome to Service Dealz Sales Portal").deliver!
  end

end
