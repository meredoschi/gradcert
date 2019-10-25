class IndexForeignKeysInRosters < ActiveRecord::Migration
  def change
    add_index :rosters, :schoolterm_id
  end
end
