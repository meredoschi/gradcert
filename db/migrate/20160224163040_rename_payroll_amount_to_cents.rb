class RenamePayrollAmountToCents < ActiveRecord::Migration
  def change
    change_table :payrolls do |t|
      t.rename :amount, :amount_cents
    end
  end
end
