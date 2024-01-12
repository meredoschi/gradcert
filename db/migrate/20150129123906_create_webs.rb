class CreateWebs < ActiveRecord::Migration[4.2]
  def change
    create_table :webs do |t|
      t.string :email, limit: 100
      t.string :site, limit: 150
      t.string :facebook, limit: 40
      t.string :twitter, limit: 40
      t.string :other, limit: 40
      t.integer :institution_id
      t.integer :contact_id
      t.timestamps
    end

    add_index :webs, %i[contact_id institution_id]
   end
end
