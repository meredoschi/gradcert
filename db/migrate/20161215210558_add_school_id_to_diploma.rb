class AddSchoolIdToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :school_id, :integer
  end
end
