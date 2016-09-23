class OrderAttribute < ActiveRecord::Base
  belongs_to :order

  def self.create_order_attributes(params,order_id)
    order_attributes = []
    params[:order_attributes].each do |attribute|
      order_attribute = self.new
      order_attribute.order_id = order_id
      attribute.each do |key,value|
        order_attribute[key] = value
      end
      if order_attribute.save!
        order_attributes << order_attribute
      end
    end
    order_attributes
  end
end
