class AddBranchidToBankAccount < ActiveRecord::Migration
  def change
    add_column :bankaccounts, :bankbranch_id, :integer
  end
end
