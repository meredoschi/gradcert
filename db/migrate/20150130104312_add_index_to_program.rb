class AddIndexToProgram < ActiveRecord::Migration[4.2]
  def change
    add_index :programs, %i[institution_id programname_id]
  end
end
