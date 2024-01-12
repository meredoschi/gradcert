class AddDaystartedDayfinishedToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :daystarted, :integer, default: 0
    add_column :payrolls, :dayfinished, :integer, default: 0
  end
end
