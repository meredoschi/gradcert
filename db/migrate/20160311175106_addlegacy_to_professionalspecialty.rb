class AddlegacyToProfessionalspecialty < ActiveRecord::Migration
  def change
    add_column :professionalspecialties, :legacy, :boolean, default: false
  end
end
