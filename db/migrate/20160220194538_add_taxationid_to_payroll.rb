class AddTaxationidToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :taxation_id, :integer
  end
end
