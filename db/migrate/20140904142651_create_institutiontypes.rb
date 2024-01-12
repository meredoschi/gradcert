class CreateInstitutiontypes < ActiveRecord::Migration[4.2]
  def change
    create_table :institutiontypes do |t|
      t.string :name, limit: 70, null: false

      t.timestamps
    end
    add_index :institutiontypes, :name, unique: true
  end
end
