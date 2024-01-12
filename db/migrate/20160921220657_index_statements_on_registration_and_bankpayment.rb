class IndexStatementsOnRegistrationAndBankpayment < ActiveRecord::Migration[4.2]
  def change
    add_index :statements, %i[bankpayment_id registration_id], unique: true
  end
end
