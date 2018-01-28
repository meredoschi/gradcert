class FixVerificationDigit < ActiveRecord::Migration
  def change
    change_table :bankaccounts do |t|
      t.rename :accountnumber, :verificationdigit # for the sake of consistency in nomenclature
    end
  end
end
