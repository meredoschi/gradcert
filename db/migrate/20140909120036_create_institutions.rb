class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name, limit: 250, null: false
      t.integer :streetname_id
      t.string :address, limit: 200, null: false
      t.string :addresscomplement, limit: 50
      t.string :neighborhood, limit: 50
      t.integer :municipality_id
      t.string :postalcode, limit: 25
      t.string :mainphone, limit: 30
      t.string :url, limit: 150
      t.string :email, limit: 100
      t.integer :institutiontype_id
      t.boolean :pap
      t.boolean :medicalresidency
      t.boolean :provisional
      t.timestamps
    end
    add_index :institutions, :name, unique: true
  end
end
