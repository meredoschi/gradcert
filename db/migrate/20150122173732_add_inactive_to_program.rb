class AddInactiveToProgram < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :inactive, :boolean, default: false
  end
end
