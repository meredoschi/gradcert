class AddBranchidToBankAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :bankaccounts, :bankbranch_id, :integer
  end
end
