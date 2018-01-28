class AddAddressIdToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :address_id, :integer
  end
end
