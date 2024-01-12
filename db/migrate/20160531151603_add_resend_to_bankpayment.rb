class AddResendToBankpayment < ActiveRecord::Migration[4.2]
  def change
    add_column :bankpayments, :resend, :boolean, default: false
  end
end
