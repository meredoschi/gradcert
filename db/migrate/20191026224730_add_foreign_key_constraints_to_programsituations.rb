class AddForeignKeyConstraintsToProgramsituations < ActiveRecord::Migration
  def change
    add_foreign_key :programsituations, :assessments
  end
end
