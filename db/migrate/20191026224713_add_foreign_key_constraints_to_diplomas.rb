class AddForeignKeyConstraintsToDiplomas < ActiveRecord::Migration
  def change
    add_foreign_key :diplomas, :councils
    add_foreign_key :diplomas, :coursenames
    add_foreign_key :diplomas, :degreetypes
    add_foreign_key :diplomas, :institutions
    add_foreign_key :diplomas, :professions
    add_foreign_key :diplomas, :schools
    add_foreign_key :diplomas, :schoolnames
    add_foreign_key :diplomas, :students
    add_foreign_key :diplomas, :supervisors
  end
end
