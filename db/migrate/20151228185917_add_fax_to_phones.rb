class AddFaxToPhones < ActiveRecord::Migration[4.2]
  def change
    add_column :phones, :fax, :string, limit: 20
  end
end
