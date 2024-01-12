class AddTotalamountToBankpayment < ActiveRecord::Migration[4.2]
  def change
    add_column :bankpayments, :totalamount_cents, :integer, default: 0
  end
end
