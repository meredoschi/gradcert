class CreatePersonalinfos < ActiveRecord::Migration[4.2]
  def change
    create_table :personalinfos do |t|
      t.string :sex
      t.string :gender
      t.date :dob
      t.string :idtype
      t.string :idnumber
      t.integer :state_id
      t.integer :country_id
      t.string :socialsecuritynumber
      t.timestamps null: false
    end
  end
end
