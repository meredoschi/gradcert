class AddStudentIdToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :student_id, :integer
  end
end
