class AddIndexToStateregion < ActiveRecord::Migration[4.2]
  def change
    add_index :stateregions, %i[brstate_id name]
  end
end
