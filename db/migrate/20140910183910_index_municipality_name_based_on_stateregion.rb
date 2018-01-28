class IndexMunicipalityNameBasedOnStateregion < ActiveRecord::Migration
  def change
    add_index :municipalities, %i[name stateregion_id], unique: true
  end
end
