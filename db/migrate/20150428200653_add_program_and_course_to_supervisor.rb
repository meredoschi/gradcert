class AddProgramAndCourseToSupervisor < ActiveRecord::Migration[4.2]
  def change
    add_column :supervisors, :program, :boolean, default: false
    add_column :supervisors, :course, :boolean, default: false
  end
end
