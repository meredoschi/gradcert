class AddDoneToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :done, :boolean, default: false # Payroll was completed
  end
end
