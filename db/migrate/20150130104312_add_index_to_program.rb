class AddIndexToProgram < ActiveRecord::Migration
  def change
    add_index :programs, %i[institution_id programname_id]
  end
end
