class RenameFundapcodeToPreviouscodeOnProfessionalspecialty < ActiveRecord::Migration[4.2]
  def change
    change_table :professionalspecialties do |t|
      t.rename :fundapcode, :previouscode # for the sake of consistency in nomenclature
    end
  end
end
