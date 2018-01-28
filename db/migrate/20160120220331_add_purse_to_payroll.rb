class AddPurseToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :purse, :integer, default: 0, null: false
  end
end
