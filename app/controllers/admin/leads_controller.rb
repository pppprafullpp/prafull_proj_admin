class Admin::LeadsController < ApplicationController
  def index
    params[:search] = {} unless params[:search].present?
    @search = Lead.new
    @breadcrumb = {'Home' => home_url, 'Leads' => ''}
    @leads = Lead.search(params[:search])
    @leads = @leads.paginate(:page => params[:page], :per_page => PER_PAGE) if @leads.present?
  end

  def create
    # raise params.to_yaml
    Lead.create!(lead_params)
    redirect_to :back
  end

  def update_lead_data
    Lead.find(params[:lead][:id]).update_attributes(:status => params[:lead][:status], :lead_response => params[:lead][:lead_response])
    flash[:success] = "Updated"
    redirect_to :back
  end

  def show_lead_details
    @lead_data = Lead.find(params[:lead_id])
    @breadcrumb = {'Home' => home_url, 'Leads' => admin_leads_path, 'Lead Detail' => ' ' }
  end



private

  def lead_params
    params.require(:lead).permit!
  end
end
