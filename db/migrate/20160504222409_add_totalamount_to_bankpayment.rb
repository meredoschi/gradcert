class AddTotalamountToBankpayment < ActiveRecord::Migration
  def change
    add_column :bankpayments, :totalamount_cents, :integer, default: 0
  end
end
