class AddForeignKeyConstraintsToSupervisors < ActiveRecord::Migration
  def change
    add_foreign_key :supervisors, :contacts
    add_foreign_key :supervisors, :professions
  end
end
