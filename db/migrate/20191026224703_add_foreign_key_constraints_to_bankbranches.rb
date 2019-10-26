class AddForeignKeyConstraintsToBankbranches < ActiveRecord::Migration
  def change
    add_foreign_key :bankbranches, :addresses
    add_foreign_key :bankbranches, :phones
  end
end
