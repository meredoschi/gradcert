class AddAccountnumberToBankaccount < ActiveRecord::Migration
  def change
    add_column :bankaccounts, :accountnumber, :string, limit: 10
  end
end
