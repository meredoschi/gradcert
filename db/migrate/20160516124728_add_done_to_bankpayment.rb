class AddDoneToBankpayment < ActiveRecord::Migration[4.2]
  def change
    add_column :bankpayments, :done, :boolean, default: false
  end
end
