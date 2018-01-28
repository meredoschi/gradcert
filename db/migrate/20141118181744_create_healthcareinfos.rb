class CreateHealthcareinfos < ActiveRecord::Migration
  def change
    create_table :healthcareinfos do |t|
      t.integer :institution_id
      t.integer :totalbeds
      t.integer :icubeds
      t.integer :ambulatoryrooms
      t.integer :labs
      t.integer :emergencyroombeds
      t.string :otherequipment, limit: 800

      t.timestamps
    end
    add_index :healthcareinfos, :institution_id, unique: true
  end
end
