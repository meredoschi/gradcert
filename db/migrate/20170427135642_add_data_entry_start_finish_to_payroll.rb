class AddDataEntryStartFinishToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :dataentrystart, :datetime
    add_column :payrolls, :dataentryfinish, :datetime
  end
end
