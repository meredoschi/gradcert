class AddSpecialToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :special, :boolean, default: false
  end
end
