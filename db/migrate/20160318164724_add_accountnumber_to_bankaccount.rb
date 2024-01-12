class AddAccountnumberToBankaccount < ActiveRecord::Migration[4.2]
  def change
    add_column :bankaccounts, :accountnumber, :string, limit: 10
  end
end
