class CreateCountries < ActiveRecord::Migration[4.2]
  def change
    create_table :countries do |t|
      t.string :nome, limit: 70, null: false
      t.string :name, limit: 70, null: false
      t.string :a2, limit: 2
      t.string :a3, limit: 3
      t.integer :numero
      t.timestamps
    end
  end
end
