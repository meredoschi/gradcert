class CreateStateregions < ActiveRecord::Migration
  def change
    create_table :stateregions do |t|
      t.string :name, limit: 70, null: false
      t.integer :brstate_id
      t.timestamps
    end
    add_index :stateregions, :name, unique: true
  end
end
