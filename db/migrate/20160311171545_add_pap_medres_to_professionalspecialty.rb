class AddPapMedresToProfessionalspecialty < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalspecialties, :pap, :boolean, default: false
    add_column :professionalspecialties, :medres, :boolean, default: false
  end
end
