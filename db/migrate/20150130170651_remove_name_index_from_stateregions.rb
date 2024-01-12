class RemoveNameIndexFromStateregions < ActiveRecord::Migration[4.2]
  def change
    remove_index :stateregions, column: [:name]
  end
end
