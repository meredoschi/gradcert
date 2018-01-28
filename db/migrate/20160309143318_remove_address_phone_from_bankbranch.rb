class RemoveAddressPhoneFromBankbranch < ActiveRecord::Migration
  def change
    change_table :bankbranches do |t|
      t.remove :address_id
      t.remove :phone_id
    end
  end
end
