class AddParentIdToProgram < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :parentid, :integer
  end
end
