class CreatePlacesavailables < ActiveRecord::Migration[4.2]
  def change
    create_table :placesavailables do |t|
      t.integer :institution_id
      t.integer :schoolterm_id
      t.integer :requested
      t.integer :accredited
      t.integer :authorized

      t.timestamps null: false
    end
  end
end
