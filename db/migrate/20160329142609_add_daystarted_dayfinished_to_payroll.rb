class AddDaystartedDayfinishedToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :daystarted, :integer, default: 0
    add_column :payrolls, :dayfinished, :integer, default: 0
  end
end
