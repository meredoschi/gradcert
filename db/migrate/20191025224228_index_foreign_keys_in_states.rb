class IndexForeignKeysInStates < ActiveRecord::Migration
  def change
    add_index :states, :country_id
  end
end
