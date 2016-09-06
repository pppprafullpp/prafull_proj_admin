class Api::V1::MobileController < ApplicationController
  #respond_to :html, :json
  #before_filter :api_access
  after_filter :set_access_control_headers
  skip_before_filter :verify_authenticity_token

  def initialize_app

  end

  def register

  end

  def login

  end

  def forgot_password

  end


  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
end