class AddProfessionalAreaandSpecialtyToProgram < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :professionalarea_id, :integer
    add_column :programs, :professionalspecialty_id, :integer
  end
end
