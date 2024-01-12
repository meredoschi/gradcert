class AddAmountToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :amount, :integer
  end
end
