class Lead < ActiveRecord::Base
#
# MEETING_STATUSES = ['Info Gathered(Net)' => 10,'Approached' => 20,'Meeting Fixed' => 30, 'Demo Completed' => 40,
#   'In Pipeline' => 50,'Signup Done' => 60,'Data Received' => 70,'Not Interested' => 80,'Using Another System' => 90,'Successfully Completed' => 100]

MEETING_STATUSES = ["INFO GATHERED","APPROCHED","MEETING FIXED","DEMO COMPLETED","IN PIPELINE","SIGNUP DONE","DATA RECIEVED","NOT INTERESTED","USING ANOTHER SYSTEM","SUCCESSFULLY COMPLETED"]

MEETING_STATUSES_IDS = [10,20,30,40,50,60,70,80,90,100]

  def self.search(params)
    # raise params.to_yaml
    conditions = []
    conditions << "lead_spoc_name like '%#{params[:lead_spoc_name]}%'" if params[:lead_spoc_name].present?
    conditions << "lead_spoc_email like '%#{params[:lead_spoc_email]}%'" if params[:lead_spoc_email].present?
    conditions << "lead_name like '%#{params[:lead_name]}%'" if params[:lead_name].present?
    conditions << "business_name like '%#{params[:business_name]}%'" if params[:business_name].present?
    # conditions << "deal_type = '#{params[:deal_type]}'" if params[:deal_type].present?
    # conditions << "service_category_id = '#{params[:service_category_id]}'" if params[:service_category_id].present?
    # conditions << "service_provider_id = '#{params[:service_provider_id]}'" if params[:service_provider_id].present?
    condition = conditions.join(' and ')
    self.where(condition)
  end

end
