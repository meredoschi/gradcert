class AddPreviousnameToProfessionalspecialty < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalspecialties, :previousname, :string, limit: 150
  end
end
