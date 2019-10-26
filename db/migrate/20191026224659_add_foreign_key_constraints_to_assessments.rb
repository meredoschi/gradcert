class AddForeignKeyConstraintsToAssessments < ActiveRecord::Migration
  def change
    add_foreign_key :assessments, :contacts
    add_foreign_key :assessments, :professions
    add_foreign_key :assessments, :programs
  end
end
