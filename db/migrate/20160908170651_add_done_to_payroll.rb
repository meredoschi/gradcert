class AddDoneToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :done, :boolean, default: false # Payroll was completed
  end
end
