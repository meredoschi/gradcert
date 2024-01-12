class AddStudentidToBankAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :bankaccounts, :student_id, :integer
  end
end
