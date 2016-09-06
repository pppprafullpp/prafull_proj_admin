class Admin::PendingActionsController < Admin::AdminApplicationController
  before_filter :set_search

  def index
    params[:search] = {} unless params[:search].present?
    @pending_actions = PendingAction.get_pending_actions(session[:id])
    @pending_actions = @pending_actions.search(params[:search])
  end

  def edit
    @pending_action = PendingAction.find(params[:id])
  end

  def update
    
    @pending_action = PendingAction.find(params[:id])
    pending_action_class = PendingAction.get_pending_action_class(@pending_action)
    #raise pending_action_class.inspect
    obj = eval(pending_action_class).approve(@pending_action.key)
    if obj and @pending_action.update_attributes(pending_action_params)
      redirect_to admin_pending_actions_path
    else
      render 'admin/pending_actions/edit'
    end
  end

  def update_ajaxified
    pending_action = PendingAction.find(params[:id])
    pending_action_class = PendingAction.get_pending_action_class(pending_action)
    mark_public = (params['action_type'] == PendingAction::APPROVE_WITH_PUBLIC) ? true : false
    if mark_public
      obj = eval(pending_action_class).approve(pending_action.key,mark_public)
    else
      obj = eval(pending_action_class).approve(pending_action.key)
    end
    pending_action.update_attributes(:status => DEACTIVE_STATUS) if obj
    @pending_actions = PendingAction.get_pending_actions(session[:id])
    respond_to do |format|
      format.js
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def pending_action_params
    params.require(:pending_action).permit(:status)
  end

  def set_search
    @search = PendingAction.new
  end
end