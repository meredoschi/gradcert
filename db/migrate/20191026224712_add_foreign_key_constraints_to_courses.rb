class AddForeignKeyConstraintsToCourses < ActiveRecord::Migration
  def change
    add_foreign_key :courses, :addresses
    add_foreign_key :courses, :coursenames
    add_foreign_key :courses, :methodologies
    add_foreign_key :courses, :professionalfamilies
    add_foreign_key :courses, :programs
    add_foreign_key :courses, :supervisors
  end
end
