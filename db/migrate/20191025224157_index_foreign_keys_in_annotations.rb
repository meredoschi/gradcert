class IndexForeignKeysInAnnotations < ActiveRecord::Migration
  def change
    add_index :annotations, :payroll_id
  end
end
