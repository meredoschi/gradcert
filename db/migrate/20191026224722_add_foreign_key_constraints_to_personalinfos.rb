class AddForeignKeyConstraintsToPersonalinfos < ActiveRecord::Migration
  def change
    add_foreign_key :personalinfos, :contacts
    add_foreign_key :personalinfos, :countries
    add_foreign_key :personalinfos, :states
  end
end
