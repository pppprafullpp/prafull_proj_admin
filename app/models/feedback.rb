class Feedback < ActiveRecord::Base
  belongs_to :user

  before_create :update_status

  private

  def update_status
    self.status = PENDING_STATUS
  end

  ## used to approve lab from pending actions class ##
  def self.approve(id)
    obj = self.find(id)
    obj.update_attributes(:status => ACTIVE_STATUS)
  end

end
