class AddForeignKeyConstraintsToBankaccounts < ActiveRecord::Migration
  def change
    add_foreign_key :bankaccounts, :bankbranches
    add_foreign_key :bankaccounts, :students
  end
end
