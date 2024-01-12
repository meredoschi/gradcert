class RemoveCourseIdfromMethodology < ActiveRecord::Migration[4.2]
  def change
    remove_column :methodologies, :course_id
  end
end
