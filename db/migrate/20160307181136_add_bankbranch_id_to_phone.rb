class AddBankbranchIdToPhone < ActiveRecord::Migration[4.2]
  def change
    add_column :phones, :bankbranch_id, :integer
  end
end
