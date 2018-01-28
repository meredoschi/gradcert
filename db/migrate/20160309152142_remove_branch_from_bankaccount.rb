class RemoveBranchFromBankaccount < ActiveRecord::Migration
  def change
    change_table :bankaccounts do |t|
      t.remove :branchnum
      t.remove :branchdigit
      t.remove :controldigit
      # Verification digit - DV Agência/Conta to be calculated programmatically
    end
  end
end
