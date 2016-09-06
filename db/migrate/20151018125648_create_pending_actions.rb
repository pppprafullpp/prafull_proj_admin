class CreatePendingActions < ActiveRecord::Migration
  def change
    create_table :pending_actions do |t|
      t.integer :action_by
      t.integer :pending_with
      t.integer :action_type
      t.integer :key
      t.integer :status
      t.text :additional_info
      t.timestamps null: false
    end
  end
end
