class IndexForeignKeysInPayrolls < ActiveRecord::Migration
  def change
    add_index :payrolls, :scholarship_id
    add_index :payrolls, :taxation_id
  end
end
