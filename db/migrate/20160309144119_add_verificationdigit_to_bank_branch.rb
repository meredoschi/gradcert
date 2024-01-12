class AddVerificationdigitToBankBranch < ActiveRecord::Migration[4.2]
  def change
    add_column :bankbranches, :verificationdigit, :string, limit: 1
  end
end
