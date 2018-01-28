class AddRegistrationPayrollIndexToAnnotations < ActiveRecord::Migration
  def change
    add_index :annotations, %i[registration_id payroll_id]
  end
end
