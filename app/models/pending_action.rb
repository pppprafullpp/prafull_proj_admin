class PendingAction < ActiveRecord::Base
## CONSTANTS FOR ACTION TYPE ##
  APPROVE_WITH_PUBLIC = 'yes'
  PACKAGE_PENDING = 21
  PACKAGE_APPROVED = 22
  SEND_REPORT = 31
  LAB_PENDING = 2
  LAB_ACTIVE = 3
  CAMPAIGN_PENDING = 50
  FEEDBACK_PENDING = 60
  DOCTOR_PENDING = 70
  PENDING_ACTIONS = {'Doctor Pending' => DOCTOR_PENDING,'Package Pending' => PACKAGE_PENDING,'Package Approved' => PACKAGE_APPROVED, 'Send Report' => SEND_REPORT, 'Lab Pending' => LAB_PENDING, 'Lab Approved' => LAB_ACTIVE,'Campaign Pending' => CAMPAIGN_PENDING,'Feedback Pending' => FEEDBACK_PENDING}


  scope :active, -> { where(status: ACTIVE_STATUS) }

  class << self

    def search(params)
      conditions = []
      conditions << "status = #{ACTIVE_STATUS}"
      condition = conditions.join(' and ')
      self.where(condition)
    end

    def create_pending_action(action_by, pending_with, action_type, key, additional_info = nil)
      action = self.where(:action_by => action_by.to_i, :pending_with => pending_with.to_i,:action_type => action_type.to_i,
                          :key => key.to_i, :status => ACTIVE_STATUS,:additional_info => additional_info).first_or_initialize
      if action.new_record?
        action.save
      else
        action.touch
      end
    end

    def get_pending_actions(pending_with,limit = 10)
      self.where(:pending_with => pending_with,:status => ACTIVE_STATUS).order("created_at desc").limit(limit)
    end

    def get_pending_actions_count(pending_with)
      self.where(:pending_with => pending_with,:status => ACTIVE_STATUS).count
    end

    def get_pending_action_class(pending_action)
      case pending_action.action_type
        when PendingAction::PACKAGE_PENDING
          'LabPackage'
        when PendingAction::SEND_REPORT
          'LabOrder'
        when PendingAction::LAB_PENDING
          'Lab'
        when PendingAction::CAMPAIGN_PENDING
          'Campaign'
        when PendingAction::FEEDBACK_PENDING
          'Feedback'
        when PendingAction::DOCTOR_PENDING
          'Doctor'
      end
    end
  end
end
