class RemoveAddressPhoneFromBankbranch < ActiveRecord::Migration[4.2]
  def change
    change_table :bankbranches do |t|
      t.remove :address_id
      t.remove :phone_id
    end
  end
end
