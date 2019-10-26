class AddForeignKeyConstraintsToMunicipalities < ActiveRecord::Migration
  def change
#    add_foreign_key :municipalities, :regionaloffices
    add_foreign_key :municipalities, :stateregions
  end
end
