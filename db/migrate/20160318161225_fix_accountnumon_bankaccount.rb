class FixAccountnumonBankaccount < ActiveRecord::Migration[4.2]
  def change
    change_table :bankaccounts do |t|
      t.remove :accountnum
    end
    add_column :bankaccounts, :num, :string, limit: 10
  end
end
