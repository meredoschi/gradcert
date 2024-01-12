class AddSchooltermToProgram < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :schoolterm_id, :integer
  end
end
