class AdminMeeting < ActiveRecord::Base
  belongs_to :admin

  validates :client_name,:client_contact_number,:client_type,:client_spoc_number,:client_spoc_name,:status, :presence => true
  validates :client_name,:client_contact_number, :uniqueness => true

  MEETING_STATUSES = {'Info Gathered(Net)' => 10,'Approached' => 20,'Meeting Fixed' => 30, 'Demo Completed' => 40, 'In Pipeline' => 50,'Signup Done' => 60,'Data Received' => 70,'Not Interested' => 80,'Using Another System' => 90,'Successfully Completed' => 100}

  def self.search(params)
    conditions = []
    conditions << "status = '#{params[:status]}'" if params[:status].present?
    condition = conditions.join(' and ')
    self.where(condition)
  end

end
