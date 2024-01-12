class AddCharacteristicidToFunding < ActiveRecord::Migration[4.2]
  def change
    add_column :fundings, :characteristic_id, :integer, null: false
    add_index :fundings, :characteristic_id
  end
end
