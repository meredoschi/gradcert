class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.integer :institution_id
      t.integer :programname_id
      t.integer :programnum
      t.string  :instprogramnum
      t.integer :duration
      t.string  :comment, limit: 200
      t.timestamps
    end
  end
end
