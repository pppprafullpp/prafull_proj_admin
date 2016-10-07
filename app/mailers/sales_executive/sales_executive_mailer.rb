class SalesExecutive::SalesExecutiveMailer < ApplicationMailer

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
