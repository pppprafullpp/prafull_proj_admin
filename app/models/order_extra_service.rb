class OrderExtraService < ActiveRecord::Base
  belongs_to :order 

  def self.create_order_extra_services(params,order_id)
    order_extra_services = []
    params[:order_extra_services].each do |extra_service|
      order_extra_service = self.new
      order_extra_service.order_id = order_id
      extra_service.each do |key,value|
        order_extra_service[key] = value
      end
      if order_extra_service.save!
        order_extra_services << order_extra_service
      end
    end
    order_extra_services
  end
end



