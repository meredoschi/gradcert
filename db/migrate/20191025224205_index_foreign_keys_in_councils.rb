class IndexForeignKeysInCouncils < ActiveRecord::Migration
  def change
    add_index :councils, :address_id
    add_index :councils, :phone_id
    add_index :councils, :state_id
    add_index :councils, :webinfo_id
  end
end
