class IndexForeignKeysInEvents < ActiveRecord::Migration
  def change
    add_index :events, :annotation_id
    add_index :events, :leavetype_id
  end
end
