class CreateProgramnames < ActiveRecord::Migration[4.2]
  def change
    create_table :programnames do |t|
      t.string :name, limit: 200, null: false
      t.timestamps
    end
    add_index :programnames, :name, unique: true
  end
end
