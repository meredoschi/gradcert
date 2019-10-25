class IndexForeignKeysInUsers < ActiveRecord::Migration
  def change
    add_index :users, :institution_id
    add_index :users, :permission_id
  end
end
