class AddPreviouscodeToProgram < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :previouscode, :string, limit: 8
  end
end
