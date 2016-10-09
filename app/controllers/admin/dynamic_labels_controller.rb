class Admin::DynamicLabelsController < Admin::AdminApplicationController


  def index
    params[:search] = {} unless params[:search].present?
    @search = DynamicLabel.new
    @dynamic_label = DynamicLabel.new
    @breadcrumb = {'Home' => home_url, 'Dynamic Labels' => ''}
    @dynamic_labels = DynamicLabel.paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  def create
    if params[:dynamic_labels] && params[:dynamic_labels][:id].present?
      DynamicLabel.find(params[:dynamic_labels][:id]).update_attributes(:label_key => params[:dynamic_labels][:label_key],:label_value => params[:dynamic_labels][:label_value],:service_provider_id => params[:dynamic_labels][:service_provider_id])
    else
      @dynamic_label = DynamicLabel.new(dynamic_label_params)
      @dynamic_label.save!
    end
    redirect_to admin_dynamic_labels_path
  end

  private

  def dynamic_label_params
    params.require(:dynamic_label).permit!
  end

end
