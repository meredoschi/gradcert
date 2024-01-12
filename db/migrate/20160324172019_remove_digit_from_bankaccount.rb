class RemoveDigitFromBankaccount < ActiveRecord::Migration[4.2]
  def change
    change_table :bankaccounts do |t|
      t.remove :digit
    end
  end
end
