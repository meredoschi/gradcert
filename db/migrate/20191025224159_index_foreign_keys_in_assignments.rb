class IndexForeignKeysInAssignments < ActiveRecord::Migration
  def change
    add_index :assignments, :supervisor_id
  end
end
