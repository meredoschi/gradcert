class AddAddressToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :address_id, :integer
  end
end
