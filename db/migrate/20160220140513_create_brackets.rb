class CreateBrackets < ActiveRecord::Migration
  def change
    create_table :brackets do |t|
      t.integer :num
      t.integer :start
      t.integer :finish
      t.boolean :unlimited, default: false
      t.integer :taxation_id

      t.timestamps null: false
    end
  end
end
