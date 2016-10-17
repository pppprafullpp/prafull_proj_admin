class DynamicLabel < ActiveRecord::Base
  validates :label_key, uniqueness: { scope: :service_provider_id,
                                 message: "Label Already exists for this Service Provider" }

  before_save {
    self.label_key = label_key.squish if label_key.present?
    self.label_value = label_value.squish if label_value.present?
  }
    def self.search(params)
    # raise params.to_yaml
    # label_key: string, label_value: string, label_description: string, service_provider_id: integer, status: integer
    conditions = []
    conditions << "service_provider_id like '%#{params[:service_provider_id]}%'" if params[:service_provider_id].present?
    conditions << "label_key like '%#{params[:label_key]}%'" if params[:label_key].present?
    conditions << "label_value like '%#{params[:label_value]}%'" if params[:label_value].present?
    conditions << "status like '%#{params[:status]}%'" if params[:status].present?
    # conditions << "deal_type = '#{params[:deal_type]}'" if params[:deal_type].present?
    # conditions << "service_category_id = '#{params[:service_category_id]}'" if params[:service_category_id].present?
    # conditions << "service_provider_id = '#{params[:service_provider_id]}'" if params[:service_provider_id].present?
    condition = conditions.join(' and ')
    self.where(condition)
    end
end
