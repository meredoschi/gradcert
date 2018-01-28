class AddTaxpayercodeToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :taxpayercode, :string, limit: 20
  end
end
