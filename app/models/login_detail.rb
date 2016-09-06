class LoginDetail < ActiveRecord::Base
  belongs_to :partnerable, :polymorphic => true
  
  def self.track_login(lab_info)
    self.create({:partnerable_type => lab_info.class.to_s, :partnerable_id => lab_info.id})
  end
end
