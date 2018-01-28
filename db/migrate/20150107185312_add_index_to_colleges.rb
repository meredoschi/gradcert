class AddIndexToColleges < ActiveRecord::Migration
  def change
    add_index :colleges, :institution_id, unique: true
  end
end
