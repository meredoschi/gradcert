class AddAddressToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :address_id, :integer
  end
end
