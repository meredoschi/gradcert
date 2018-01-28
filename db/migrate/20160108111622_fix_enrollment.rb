class FixEnrollment < ActiveRecord::Migration
  def change
    if table_exists?(:enrollments)

      change_table :enrollments do |t|
        t.remove :program_id
      end
      add_column :enrollments, :student_id, :integer
      end
    end
end
