class IndexForeignKeysInBrackets < ActiveRecord::Migration
  def change
    add_index :brackets, :taxation_id
  end
end
