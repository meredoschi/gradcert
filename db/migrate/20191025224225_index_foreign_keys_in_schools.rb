class IndexForeignKeysInSchools < ActiveRecord::Migration
  def change
    add_index :schools, :academiccategory_id
  end
end
