class AddForeignKeyConstraintsToPhones < ActiveRecord::Migration
  def change
    add_foreign_key :phones, :bankbranches
    add_foreign_key :phones, :contacts
    add_foreign_key :phones, :councils
    add_foreign_key :phones, :institutions
    add_foreign_key :phones, :regionaloffices
  end
end
