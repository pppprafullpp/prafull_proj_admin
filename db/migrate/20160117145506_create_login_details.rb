class CreateLoginDetails < ActiveRecord::Migration
  def change
    create_table :login_details do |t|
      t.string  :partnerable_type
      t.integer :partnerable_id
      t.timestamps null: false
    end
  end
end
