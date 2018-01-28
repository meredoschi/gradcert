class RemoveNameIndexFromStateregions < ActiveRecord::Migration
  def change
    remove_index :stateregions, column: [:name]
  end
end
