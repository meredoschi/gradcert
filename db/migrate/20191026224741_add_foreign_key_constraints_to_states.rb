class AddForeignKeyConstraintsToStates < ActiveRecord::Migration
  def change
    add_foreign_key :states, :countries
  end
end
