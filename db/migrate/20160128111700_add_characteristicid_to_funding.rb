class AddCharacteristicidToFunding < ActiveRecord::Migration
  def change
    add_column :fundings, :characteristic_id, :integer, null: false
    add_index :fundings, :characteristic_id
  end
end
