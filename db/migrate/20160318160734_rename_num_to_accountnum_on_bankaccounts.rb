class RenameNumToAccountnumOnBankaccounts < ActiveRecord::Migration[4.2]
  def change
    change_table :bankaccounts do |t|
      t.rename :num, :accountnum # for the sake of consistency in nomenclature
    end
  end
end
