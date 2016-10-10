class UserGift < ActiveRecord::Base
	belongs_to :app_user
	belongs_to :order
	belongs_to :gift


	def self.create_user_gift(order_id)
		order = Order.find_by_id(order_id)
		if order.present?
			app_user = order.app_user
			if app_user.present?
				orders_count = app_user.orders.count
				gift = Gift.find_by_activation_count_condition(orders_count)
				gift_id = gift.try(:id)
				user_gifts = order.user_gifts.create(:gift_id => gift_id, :app_user_id => app_user.id)
				gift_amount = gift.amount.present? ? gift.amount : 0
				app_user.update_attributes(:total_amount => app_user.total_amount + gift_amount)
			end
		end
	end

end
