class RaterController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    if is_user?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, current_user, params[:dimension]

      render :json => true
    else
      render :json => false
    end
  end
end
