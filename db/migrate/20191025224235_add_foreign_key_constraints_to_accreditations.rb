class AddForeignKeyConstraintsToAccreditations < ActiveRecord::Migration
  def change
    add_foreign_key :accreditations, :institutions
    add_foreign_key :accreditations, :programs
    add_foreign_key :accreditations, :registrations
  end
end
