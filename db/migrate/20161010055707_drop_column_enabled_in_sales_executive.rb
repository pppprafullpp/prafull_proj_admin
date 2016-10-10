class DropColumnEnabledInSalesExecutive < ActiveRecord::Migration
  def change
    remove_column :sales_executives, :enabled
    add_column :sales_executives, :status, :integer
  end
end
