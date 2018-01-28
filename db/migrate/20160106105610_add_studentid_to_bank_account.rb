class AddStudentidToBankAccount < ActiveRecord::Migration
  def change
    add_column :bankaccounts, :student_id, :integer
  end
end
