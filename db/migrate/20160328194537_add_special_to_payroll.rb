class AddSpecialToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :special, :boolean, default: false
  end
end
