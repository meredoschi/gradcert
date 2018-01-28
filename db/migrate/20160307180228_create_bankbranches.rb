class CreateBankbranches < ActiveRecord::Migration
  def change
    create_table :bankbranches do |t|
      t.integer :num
      t.string :name, limit: 100
      t.string :formername, limit: 50
      t.integer :address_id
      t.integer :phone_id
      t.timestamps null: false
    end
  end
end
