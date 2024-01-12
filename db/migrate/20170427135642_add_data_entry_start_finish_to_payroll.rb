class AddDataEntryStartFinishToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :dataentrystart, :datetime
    add_column :payrolls, :dataentryfinish, :datetime
  end
end
