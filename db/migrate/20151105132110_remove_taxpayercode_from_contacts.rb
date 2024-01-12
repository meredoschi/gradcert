class RemoveTaxpayercodeFromContacts < ActiveRecord::Migration[4.2]
  def change
    change_table :contacts do |t|
      t.remove :taxpayercode
    end
  end
end
