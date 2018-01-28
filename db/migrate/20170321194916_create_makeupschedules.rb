class CreateMakeupschedules < ActiveRecord::Migration
  def change
    create_table :makeupschedules do |t|
      t.date :start
      t.date :finish
      t.integer :registration_id

      t.timestamps null: false
    end
    add_index :makeupschedules, :registration_id, unique: true
  end
end
