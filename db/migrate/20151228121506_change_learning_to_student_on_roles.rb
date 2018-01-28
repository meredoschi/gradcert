class ChangeLearningToStudentOnRoles < ActiveRecord::Migration
  def change
    rename_column :roles, :learning, :student
  end
end
