class AddForeignKeyConstraintsToInstitutions < ActiveRecord::Migration
  def change
    add_foreign_key :institutions, :accreditations
    add_foreign_key :institutions, :addresses
    add_foreign_key :institutions, :institutiontypes
    add_foreign_key :institutions, :phones
    add_foreign_key :institutions, :webinfos
  end
end
