class CreateSchoolyears < ActiveRecord::Migration[4.2]
  def change
    create_table :schoolyears do |t|
      t.integer :programyear
      t.integer :grants
      t.integer :maxenrollment
      t.integer :band_id
      t.timestamps
    end
    add_index :schoolyears, %i[band_id programyear]
  end
end
