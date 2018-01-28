class AddCourseIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :course_id, :integer
  end
end
