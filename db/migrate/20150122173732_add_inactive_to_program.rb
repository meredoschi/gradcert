class AddInactiveToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :inactive, :boolean, default: false
  end
end
