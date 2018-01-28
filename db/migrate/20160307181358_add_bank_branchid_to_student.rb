class AddBankBranchidToStudent < ActiveRecord::Migration
  def change
    add_column :students, :bankbranch_id, :integer
  end
end
