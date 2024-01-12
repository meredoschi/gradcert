class IndexMunicipalityNameBasedOnStateregion < ActiveRecord::Migration[4.2]
  def change
    add_index :municipalities, %i[name stateregion_id], unique: true
  end
end
