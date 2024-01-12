class ChangeLearningToStudentOnRoles < ActiveRecord::Migration[4.2]
  def change
    rename_column :roles, :learning, :student
  end
end
