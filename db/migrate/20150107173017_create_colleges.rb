class CreateColleges < ActiveRecord::Migration[4.2]
  def change
    create_table :colleges do |t|
      t.integer :institution_id
      t.integer :area
      t.integer :classrooms
      t.integer :otherrooms
      t.integer :sportscourts
      t.integer :foodplaces
      t.integer :libraries
      t.integer :gradcertificatecourses
      t.integer :previousyeargradcertcompletions

      t.timestamps
    end
  end
end
