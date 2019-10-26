class AddForeignKeyConstraintsToContacts < ActiveRecord::Migration
  def change
    add_foreign_key :contacts, :addresses
    add_foreign_key :contacts, :personalinfos
    add_foreign_key :contacts, :phones
    add_foreign_key :contacts, :roles
    add_foreign_key :contacts, :users
    add_foreign_key :contacts, :webinfos
  end
end
