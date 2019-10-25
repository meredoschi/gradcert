class AddForeignKeyConstraintsToAddresses < ActiveRecord::Migration
  def change
    add_foreign_key :addresses, :institutions
    add_foreign_key :addresses, :bankbranches
    add_foreign_key :addresses, :contacts
    add_foreign_key :addresses, :councils
    add_foreign_key :addresses, :countries
    add_foreign_key :addresses, :courses
    add_foreign_key :addresses, :municipalities
    add_foreign_key :addresses, :programs
    add_foreign_key :addresses, :regionaloffices
    add_foreign_key :addresses, :streetnames
  end
end
