class AddVerificationdigitToBankBranch < ActiveRecord::Migration
  def change
    add_column :bankbranches, :verificationdigit, :string, limit: 1
  end
end
