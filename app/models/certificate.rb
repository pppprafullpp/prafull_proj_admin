class Certificate < ActiveRecord::Base
  validates :name, :achievement,:year_of_achievement, :presence => true
  
  has_attached_file :achievement, :styles => { medium: "700x700>", thumb:  "75x75>" },
                            :path => "public/system/certificates/:doctor_id/:style_:filename",
                            :url => "/system/certificates/:doctor_id/:style_:basename.:extension"
                            
  validates_attachment :achievement, content_type: { content_type: /\Aimage\/.*\Z/ },
                               size: { less_than: IMAGE_LIMIT.megabytes }
  
  belongs_to :doctor
  
  before_create :set_status
  extend Notify

  def self.search(params)
    conditions = []
    conditions << "name ilike '%#{params[:name]}%'" if params[:name].present?
    conditions << "status = '#{params[:status]}'" if params[:status].present?
    condition = conditions.join(' and ')
    self.where(condition)
  end

  def self.fetch_certificates(current_user)
    role = current_user.class.to_s
    if role.eql? Admin::ADMIN
      self.all
    elsif role.eql? Admin::DOCTOR
      if current_user.id.present? 
        self.where("doctor_id = ?", current_user.id) 
       else
        doc_ids =  Dcotor.where("id = ? OR doctor_id = ?", current_user.id, current_user.id).collect{|doc| doc.id}
        self.where("doctor_id IN (?)", doc_ids)
       end 
    end
  end
  
  
  
  
  
  
  protected
  
  def set_status
    self.status = ACTIVE_STATUS
  end
  
end
