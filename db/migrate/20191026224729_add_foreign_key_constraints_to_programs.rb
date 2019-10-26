class AddForeignKeyConstraintsToPrograms < ActiveRecord::Migration
  def change
    add_foreign_key :programs, :accreditations
    add_foreign_key :programs, :addresses
    add_foreign_key :programs, :admissions
    add_foreign_key :programs, :institutions
  #  add_foreign_key :programs, :professionalspecialties
    add_foreign_key :programs, :programnames
    add_foreign_key :programs, :schoolterms
  end
end
