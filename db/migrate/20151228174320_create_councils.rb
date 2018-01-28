class CreateCouncils < ActiveRecord::Migration
  def change
    create_table :councils do |t|
      t.string :name, limit: 150, null: false
      t.integer :address_id
      t.integer :phone_id
      t.integer :webinfo_id
      t.integer :state_id
      t.timestamps null: false
    end
  end
end
