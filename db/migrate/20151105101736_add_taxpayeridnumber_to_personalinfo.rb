class AddTaxpayeridnumberToPersonalinfo < ActiveRecord::Migration
  def change
    add_column :personalinfos, :tin, :string, limit: 20 # Taxpayer Identification Number - e.g. Brazilian CPF
  end
end
