class CreateResearchcenters < ActiveRecord::Migration
  def change
    create_table :researchcenters do |t|
      t.integer :institution_id
      t.integer :rooms
      t.integer :labs
      t.integer :intlprojectsdone
      t.integer :ongoingintlprojects
      t.integer :domesticprojectsdone
      t.integer :ongoingdomesticprojects

      t.timestamps
    end
    add_index :researchcenters, :institution_id, unique: true
  end
end
