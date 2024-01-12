class AddIndexToColleges < ActiveRecord::Migration[4.2]
  def change
    add_index :colleges, :institution_id, unique: true
  end
end
