class IndexForeignKeysInContacts < ActiveRecord::Migration
  def change
    add_index :contacts, :address_id
    add_index :contacts, :personalinfo_id
    add_index :contacts, :phone_id
    add_index :contacts, :webinfo_id
  end
end
