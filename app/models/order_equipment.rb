class OrderEquipment < ActiveRecord::Base
  belongs_to :order

  def self.create_order_equipments(params,order_id)
    order_equipments = []
    params[:order_equipments].each do |equipment|
      order_equipment = self.new
      order_equipment.order_id = order_id
      equipment.each do |key,value|
        order_equipment[key] = value
      end
      if order_equipment.save!
        order_equipments << order_equipment
      end
    end
    order_equipments
  end
end
