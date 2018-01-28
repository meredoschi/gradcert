class AddDoneToBankpayment < ActiveRecord::Migration
  def change
    add_column :bankpayments, :done, :boolean, default: false
  end
end
