class AddMonthPertainingToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :monthworked, :date
  end
end
