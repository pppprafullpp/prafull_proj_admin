class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.text :lead_type
      t.integer :service_category_id
      t.integer :deal_id
      t.text :lead_name
      t.text :lead_description
      t.text :lead_email
      t.text :lead_contact_number
      t.text :lead_location
      t.text :lead_address
      t.text :lead_spoc_name
      t.text :lead_spoc_email
      t.text :lead_spoc_number
      t.text :lead_spoc_designation
      t.text :lead_response
      t.text :user_id
      t.text :status
      t.datetime :demo_time

      t.timestamps null: false
    end
  end
end
