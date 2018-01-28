class AddAmountToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :amount, :integer
  end
end
