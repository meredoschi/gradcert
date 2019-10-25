class IndexForeignKeysInPlacesavailables < ActiveRecord::Migration
  def change
    add_index :placesavailables, :institution_id
    add_index :placesavailables, :schoolterm_id
  end
end
