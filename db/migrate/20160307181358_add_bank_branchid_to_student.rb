class AddBankBranchidToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :bankbranch_id, :integer
  end
end
