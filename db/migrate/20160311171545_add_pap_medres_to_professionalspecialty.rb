class AddPapMedresToProfessionalspecialty < ActiveRecord::Migration
  def change
    add_column :professionalspecialties, :pap, :boolean, default: false
    add_column :professionalspecialties, :medres, :boolean, default: false
  end
end
