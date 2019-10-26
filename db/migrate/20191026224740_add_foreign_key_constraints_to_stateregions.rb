class AddForeignKeyConstraintsToStateregions < ActiveRecord::Migration
  def change
    add_foreign_key :stateregions, :states
  end
end
