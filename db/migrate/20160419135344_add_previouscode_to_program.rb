class AddPreviouscodeToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :previouscode, :string, limit: 8
  end
end
