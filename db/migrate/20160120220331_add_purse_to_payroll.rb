class AddPurseToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :purse, :integer, default: 0, null: false
  end
end
