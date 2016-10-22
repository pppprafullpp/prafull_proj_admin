class AddIsOrderAvailableFlagToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :is_order_available, :boolean,:default => true
  end
end
