class AddParentIdToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :parentid, :integer
  end
end
