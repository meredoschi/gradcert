class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.integer :institution_id
      t.string :mission, limit: 800
      t.string :corevalues, limit: 800
      t.string :userprofile, limit: 800
      t.integer :stateregion_id
      t.string :relationwithpublichealthcare, limit: 800
      t.float :publicfundinglevel
      t.string :highlightareas, limit: 800
      t.timestamps
    end
    add_index :characteristics, :institution_id, unique: true
  end
end
