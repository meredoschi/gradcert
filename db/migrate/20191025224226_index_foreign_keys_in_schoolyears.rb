class IndexForeignKeysInSchoolyears < ActiveRecord::Migration
  def change
    add_index :schoolyears, :program_id
  end
end
