class AddIndexToStateregion < ActiveRecord::Migration
  def change
    add_index :stateregions, %i[brstate_id name]
  end
end
