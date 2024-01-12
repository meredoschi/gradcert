class RemoveOldAddresscolumnsFromInstitution < ActiveRecord::Migration[4.2]
  def change
    change_table :institutions do |t|
      t.remove :address
      t.remove :addresscomplement
      t.remove :neighborhood
      t.remove :municipality_id
      t.remove :postalcode
      t.remove :streetname_id
    end
  end
end
