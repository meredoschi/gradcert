class IndexForeignKeysInMunicipalities < ActiveRecord::Migration
  def change
    add_index :municipalities, :regionaloffice_id
    add_index :municipalities, :stateregion_id
  end
end
