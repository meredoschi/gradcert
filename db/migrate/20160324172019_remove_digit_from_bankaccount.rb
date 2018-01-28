class RemoveDigitFromBankaccount < ActiveRecord::Migration
  def change
    change_table :bankaccounts do |t|
      t.remove :digit
    end
  end
end
