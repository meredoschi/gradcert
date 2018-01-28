class RemoveTaxpayercodeFromContacts < ActiveRecord::Migration
  def change
    change_table :contacts do |t|
      t.remove :taxpayercode
    end
  end
end
