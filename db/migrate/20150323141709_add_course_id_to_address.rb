class AddCourseIdToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :course_id, :integer
  end
end
