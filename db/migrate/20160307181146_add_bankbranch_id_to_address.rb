class AddBankbranchIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :bankbranch_id, :integer
  end
end
