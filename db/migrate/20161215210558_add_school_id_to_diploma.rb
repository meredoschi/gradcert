class AddSchoolIdToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :school_id, :integer
  end
end
