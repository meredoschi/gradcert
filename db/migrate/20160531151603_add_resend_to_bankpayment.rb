class AddResendToBankpayment < ActiveRecord::Migration
  def change
    add_column :bankpayments, :resend, :boolean, default: false
  end
end
