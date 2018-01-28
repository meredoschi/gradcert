class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :streetname_id
      t.string  :addr, limit: 200
      t.string  :complement, limit: 50
      t.string :neighborhood, limit: 50
      t.integer :municipality_id
      t.string  :postalcode, limit: 25
      t.timestamps
    end
  end
end
