class IndexForeignKeysInCharacteristics < ActiveRecord::Migration
  def change
    add_index :characteristics, :stateregion_id
  end
end
