class AddAddressIdToInstitution < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :address_id, :integer
  end
end
