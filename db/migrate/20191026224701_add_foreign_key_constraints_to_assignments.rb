class AddForeignKeyConstraintsToAssignments < ActiveRecord::Migration
  def change
    add_foreign_key :assignments, :programs
    add_foreign_key :assignments, :supervisors
  end
end
