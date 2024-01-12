class SetAmountDefaultsOnPayroll < ActiveRecord::Migration[4.2]
  def change
    change_table :payrolls do |t|
      t.remove :amount
    end

    add_column :payrolls, :amount, :integer, null: false, default: 0
  end
end
