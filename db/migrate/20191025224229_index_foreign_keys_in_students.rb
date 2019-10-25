class IndexForeignKeysInStudents < ActiveRecord::Migration
  def change
    add_index :students, :profession_id
  end
end
