class ChangeBankaccountnumtoString < ActiveRecord::Migration
  def change
    change_table :bankaccounts do |t|
      t.remove :num
    end

    add_column :bankaccounts, :num, :string, limit: 30
  end
end
