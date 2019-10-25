class AddForeignKeyConstraintToAdmissionsProgramId < ActiveRecord::Migration
  def change
    add_foreign_key :admissions, :programs
  end
end
