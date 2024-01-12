class AddIndexToAssignment < ActiveRecord::Migration[4.2]
  def change
    add_index :assignments, %i[program_id supervisor_id]
  end
end
