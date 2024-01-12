class AddlegacyToProfessionalspecialty < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalspecialties, :legacy, :boolean, default: false
  end
end
