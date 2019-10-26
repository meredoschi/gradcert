class AddForeignKeyConstraintsToRegistrations < ActiveRecord::Migration
  def change
    add_foreign_key :registrations, :accreditations
    add_foreign_key :registrations, :completions
    add_foreign_key :registrations, :registrationkinds
    add_foreign_key :registrations, :schoolyears
    add_foreign_key :registrations, :students
  end
end
