class CreateProfessions < ActiveRecord::Migration
  def change
    create_table :professions do |t|
      t.string :name, limit: 100, null: false
      t.integer :occupationcode
      t.timestamps
    end
  end
end
