class AddRegistrationPayrollIndexToAnnotations < ActiveRecord::Migration[4.2]
  def change
    add_index :annotations, %i[registration_id payroll_id]
  end
end
