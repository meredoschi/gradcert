class RemoveCourseIdfromMethodology < ActiveRecord::Migration
  def change
    remove_column :methodologies, :course_id
  end
end
