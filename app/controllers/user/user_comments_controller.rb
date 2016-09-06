class User::UserCommentsController < User::UserApplicationController

  def index
    @user_comments = []
    commentable_id = params[:commentable_id]
    commentable_type = params[:commentable_type]
    if commentable_type.present? && commentable_id.present?
      @obj = eval(commentable_type).find(commentable_id)
      @user_comments = UserComment.joins("inner join users on users.id = user_comments.creator_id").select("user_comments.*,users.first_name,users.last_name").where(:commentable_id => commentable_id,:commentable_type => commentable_type).order("created_at desc").limit(10)
    end
    respond_to do |format|
      format.js {render :template => 'shared/user_comments'}
    end
  end

  def create
    if is_user?
      commentable_id = params[:commentable_id]
      commentable_type = params[:commentable_type]
      body = params[:comment]
      comment = UserComment.create(:commentable_id => commentable_id, :commentable_type => commentable_type, :creator_id => session[:id],:body => body, :status => DEACTIVE_STATUS)
    end
    redirect_to request.referer
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_address_param
    params.require(:user_address).permit(:user_id,:nickname,:address1, :address2,:contact_number,:city_id,:city_location_id,:landmark,:status)
  end
end
