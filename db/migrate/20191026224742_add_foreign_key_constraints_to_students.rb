class AddForeignKeyConstraintsToStudents < ActiveRecord::Migration
  def change
    add_foreign_key :students, :bankaccounts
    add_foreign_key :students, :contacts
    add_foreign_key :students, :professions
    add_foreign_key :students, :schoolterms
  end
end
