class AddFaxToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :fax, :string, limit: 20
  end
end
