class AddTaxationidToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :taxation_id, :integer
  end
end
