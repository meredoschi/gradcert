class RenameMedicalResidencyToMedresInstitutions < ActiveRecord::Migration[4.2]
  def change
    change_table :institutions do |t|
      t.rename :medicalresidency, :medres # for the sake of consistency in nomenclature
    end
  end
end
