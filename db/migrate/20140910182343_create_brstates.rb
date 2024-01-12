class CreateBrstates < ActiveRecord::Migration[4.2]
  def change
    create_table :brstates do |t|
      t.string :name, limit: 50, null: false
      t.string :abbreviation
    end
    add_index :brstates, :name, unique: true
  end
end
