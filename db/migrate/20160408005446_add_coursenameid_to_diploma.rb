class AddCoursenameidToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :coursename_id, :integer
  end
end
