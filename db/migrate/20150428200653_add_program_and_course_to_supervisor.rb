class AddProgramAndCourseToSupervisor < ActiveRecord::Migration
  def change
    add_column :supervisors, :program, :boolean, default: false
    add_column :supervisors, :course, :boolean, default: false
  end
end
