class AddBusinessNameToLead < ActiveRecord::Migration
  def change
    add_column :leads, :business_name, :text
  end
end
