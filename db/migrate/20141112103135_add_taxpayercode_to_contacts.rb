class AddTaxpayercodeToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :taxpayercode, :string, limit: 20
  end
end
