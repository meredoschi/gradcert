class IndexStudentSchoolyearRegistrations < ActiveRecord::Migration
  def change
    add_index :registrations, %i[student_id schoolyear_id], unique: true
  end
end
