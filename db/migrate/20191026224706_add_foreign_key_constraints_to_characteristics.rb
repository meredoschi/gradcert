class AddForeignKeyConstraintsToCharacteristics < ActiveRecord::Migration
  def change
    add_foreign_key :characteristics, :institutions
    add_foreign_key :characteristics, :stateregions
  end
end
