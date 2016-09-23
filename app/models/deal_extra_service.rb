class DealExtraService < ActiveRecord::Base
  belongs_to :extra_service

  def service_name
    self.extra_service.service_name
  end

  def service_description
    self.extra_service.service_description
  end
end
