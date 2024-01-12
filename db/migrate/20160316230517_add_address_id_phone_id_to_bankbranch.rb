class AddAddressIdPhoneIdToBankbranch < ActiveRecord::Migration[4.2]
  def change
    add_column :bankbranches, :address_id, :integer
    add_column :bankbranches, :phone_id, :integer
  end
end
