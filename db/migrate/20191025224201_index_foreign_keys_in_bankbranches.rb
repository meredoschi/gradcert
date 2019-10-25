class IndexForeignKeysInBankbranches < ActiveRecord::Migration
  def change
    add_index :bankbranches, :address_id
    add_index :bankbranches, :phone_id
  end
end
