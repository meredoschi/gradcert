class AddStudentIdToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :student_id, :integer
  end
end
