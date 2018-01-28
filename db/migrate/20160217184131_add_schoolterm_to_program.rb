class AddSchooltermToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :schoolterm_id, :integer
  end
end
