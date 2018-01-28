class AddPurseCentsToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :purse_cents, :integer, default: 0, null: false
  end
end
