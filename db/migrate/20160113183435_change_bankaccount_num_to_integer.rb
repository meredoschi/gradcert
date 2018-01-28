class ChangeBankaccountNumToInteger < ActiveRecord::Migration
  def change
    change_table :bankaccounts do |t|
      t.remove :num
    end
    add_column :bankaccounts, :num, :integer
  end
end
