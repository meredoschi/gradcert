class CreateProfessions < ActiveRecord::Migration[4.2]
  def change
    create_table :professions do |t|
      t.string :name, limit: 100, null: false
      t.integer :occupationcode
      t.timestamps
    end
  end
end
