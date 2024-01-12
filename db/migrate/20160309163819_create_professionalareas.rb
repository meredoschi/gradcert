class CreateProfessionalareas < ActiveRecord::Migration[4.2]
  def change
    create_table :professionalareas do |t|
      t.string :name, limit: 100
      t.string :previouscode, limit: 10
      t.timestamps null: false
    end
  end
end
