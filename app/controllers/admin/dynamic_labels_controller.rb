class Admin::DynamicLabelsController < Admin::AdminApplicationController


  def index
    params[:search] = {} unless params[:search].present?
    @search = DynamicLabel.new
    @breadcrumb = {'Home' => home_url, 'Dynamic Labels' => ''}
    @dynamic_labels = DynamicLabel.search(params[:search]).paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  def create
    # raise params.to_yaml
    if params[:dynamic_label][:id].present?
      DynamicLabel.find(params[:dynamic_label][:id]).update_attributes(:label_key => params[:dynamic_label][:label_key],:label_value => params[:dynamic_label][:label_value],:service_provider_id => params[:dynamic_label][:service_provider_id], :status => params[:dynamic_label][:status])
    else
       @dynamic_label = DynamicLabel.new(dynamic_label_params)
       if @dynamic_label.valid?
         @dynamic_label.save!
     else
       flash[:warning] = "Already Exists"
      end
    end
    redirect_to admin_dynamic_labels_path
  end

  private

  def dynamic_label_params
    params.require(:dynamic_label).permit!
  end

end
