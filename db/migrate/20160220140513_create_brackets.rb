class CreateBrackets < ActiveRecord::Migration[4.2]
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
