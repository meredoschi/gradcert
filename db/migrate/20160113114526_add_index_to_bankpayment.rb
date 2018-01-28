class AddIndexToBankpayment < ActiveRecord::Migration
  def change
    add_index :bankpayments, :payroll_id
  end
end
