class DynamicLabel < ActiveRecord::Base
  validates :label_key, uniqueness: { scope: :service_provider_id,
                                 message: "Label Already exists for this Service Provider" }

  before_save {
    self.label_key = label_key.squish if label_key.present?
    self.label_value = label_value.squish if label_value.present?
  }
end
