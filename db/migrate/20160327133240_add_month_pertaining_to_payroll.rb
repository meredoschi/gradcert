class AddMonthPertainingToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :monthworked, :date
  end
end
