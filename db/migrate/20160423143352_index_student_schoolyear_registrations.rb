class IndexStudentSchoolyearRegistrations < ActiveRecord::Migration[4.2]
  def change
    add_index :registrations, %i[student_id schoolyear_id], unique: true
  end
end
