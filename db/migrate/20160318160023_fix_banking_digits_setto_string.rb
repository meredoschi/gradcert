class FixBankingDigitsSettoString < ActiveRecord::Migration
  def change
    change_column :bankaccounts, :num, :string, limit: 10
    change_column :bankbranches, :code, :string, limit: 5
  end
end
