class AddPreviousnameToProfessionalspecialty < ActiveRecord::Migration
  def change
    add_column :professionalspecialties, :previousname, :string, limit: 150
  end
end
