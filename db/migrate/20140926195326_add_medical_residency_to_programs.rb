class AddMedicalResidencyToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :medres, :boolean, default: false
  end
end
