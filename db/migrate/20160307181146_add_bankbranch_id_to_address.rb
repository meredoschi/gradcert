class AddBankbranchIdToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :bankbranch_id, :integer
  end
end
