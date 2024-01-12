class Allownulladdress < ActiveRecord::Migration[4.2]
  def change
    change_column_null(:contacts, :address, true)
  end
end
