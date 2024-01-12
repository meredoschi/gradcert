class CreateContacts < ActiveRecord::Migration[4.2]
  def change
    create_table :contacts do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false
      t.string :salutation, limit: 25
      t.string :name,  null: false, limit: 150
      t.string :phone, limit: 30
      t.string :phone2, limit: 30
      t.integer :streetname_id
      t.string :address, limit: 200, null: false
      t.string :addresscomplement, limit: 50
      t.string :neighborhood, limit: 50
      t.integer :municipality_id
      t.string :postalcode, limit: 25
      t.string :mobile, limit: 30
      t.date :termstart
      t.date :termend
      t.timestamps
    end
  end
end
