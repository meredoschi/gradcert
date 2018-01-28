class IndexAddressOnMunicipalityId < ActiveRecord::Migration
  def change
    add_index :addresses, [:municipality_id]
  end
end
