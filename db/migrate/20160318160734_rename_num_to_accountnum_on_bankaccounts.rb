class RenameNumToAccountnumOnBankaccounts < ActiveRecord::Migration
  def change
    change_table :bankaccounts do |t|
      t.rename :num, :accountnum # for the sake of consistency in nomenclature
    end
  end
end
