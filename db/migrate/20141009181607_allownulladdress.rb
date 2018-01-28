class Allownulladdress < ActiveRecord::Migration
  def change
    change_column_null(:contacts, :address, true)
  end
end
