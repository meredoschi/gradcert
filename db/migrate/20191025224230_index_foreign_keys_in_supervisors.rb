class IndexForeignKeysInSupervisors < ActiveRecord::Migration
  def change
    add_index :supervisors, :profession_id
  end
end
