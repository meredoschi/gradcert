class AddMedicalResidencyToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :medres, :boolean, default: false
  end
end
