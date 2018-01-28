class CreateRegionaloffices < ActiveRecord::Migration
  def change
    create_table :regionaloffices do |t|
      t.string :name, limit: 100, null: false, unique: true
      t.integer :num, unique: true
      t.references :address, index: true
      t.references :phone, index: true
      t.references :webinfo, index: true
      t.timestamps
    end
  end
end
