class RenameFundapcodeToPreviouscodeOnProfessionalspecialty < ActiveRecord::Migration
  def change
    change_table :professionalspecialties do |t|
      t.rename :fundapcode, :previouscode # for the sake of consistency in nomenclature
    end
  end
end
