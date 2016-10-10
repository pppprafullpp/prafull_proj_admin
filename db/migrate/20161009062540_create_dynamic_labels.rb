class CreateDynamicLabels < ActiveRecord::Migration
  def change
    create_table :dynamic_labels do |t|
      t.string :label_key
      t.string :label_value
      t.string :label_description
      t.integer :service_provider_id
      t.integer :status
      t.timestamps null: false
    end
  end
end
