class IndexStatementsOnRegistrationAndBankpayment < ActiveRecord::Migration
  def change
    add_index :statements, %i[bankpayment_id registration_id], unique: true
  end
end
