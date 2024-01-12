class AddIndexToBankpayment < ActiveRecord::Migration[4.2]
  def change
    add_index :bankpayments, :payroll_id
  end
end
