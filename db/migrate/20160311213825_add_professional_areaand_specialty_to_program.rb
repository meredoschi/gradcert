class AddProfessionalAreaandSpecialtyToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :professionalarea_id, :integer
    add_column :programs, :professionalspecialty_id, :integer
  end
end
