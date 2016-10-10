class CreateSalesExecutives < ActiveRecord::Migration
  def change
    create_table :sales_executives do |t|
      t.string :name
      t.string :email
      t.string :role
      t.string :encrypted_password
      t.string :reset_password_token
      t.datetime :remember_created_at
      t.integer :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.boolean :enabled
      t.integer :failed_count
      t.datetime :password_updated_at
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps null: false
    end
  end
end
