class AddIndexToAssignment < ActiveRecord::Migration
  def change
    add_index :assignments, %i[program_id supervisor_id]
  end
end
