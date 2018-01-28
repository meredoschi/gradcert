class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :start
      t.date :finish
      t.integer :leavetype_id
      t.boolean :absence, default: false
      t.timestamps null: false
    end
  end
end
