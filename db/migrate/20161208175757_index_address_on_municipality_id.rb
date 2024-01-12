class IndexAddressOnMunicipalityId < ActiveRecord::Migration[4.2]
  def change
    add_index :addresses, [:municipality_id]
  end
end
