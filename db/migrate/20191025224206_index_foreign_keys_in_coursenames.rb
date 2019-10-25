class IndexForeignKeysInCoursenames < ActiveRecord::Migration
  def change
    add_index :coursenames, :school_id
  end
end
