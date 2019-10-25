class IndexForeignKeysInBankaccounts < ActiveRecord::Migration
  def change
    add_index :bankaccounts, :bankbranch_id
    add_index :bankaccounts, :student_id
  end
end
