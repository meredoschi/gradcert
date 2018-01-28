class AddBankbranchIdToPhone < ActiveRecord::Migration
  def change
    add_column :phones, :bankbranch_id, :integer
  end
end
