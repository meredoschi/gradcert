class AddCoursenameidToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :coursename_id, :integer
  end
end
