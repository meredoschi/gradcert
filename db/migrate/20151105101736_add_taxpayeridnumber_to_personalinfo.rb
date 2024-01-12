class AddTaxpayeridnumberToPersonalinfo < ActiveRecord::Migration[4.2]
  def change
    add_column :personalinfos, :tin, :string, limit: 20 # Taxpayer Identification Number - e.g. Brazilian CPF
  end
end
