class RenamePayrollAmountToCents < ActiveRecord::Migration[4.2]
  def change
    change_table :payrolls do |t|
      t.rename :amount, :amount_cents
    end
  end
end
