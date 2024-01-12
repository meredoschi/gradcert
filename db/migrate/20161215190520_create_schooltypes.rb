class CreateSchooltypes < ActiveRecord::Migration[4.2]
  def change
    create_table :schooltypes do |t|
      t.string :name, limit: 70

      t.timestamps null: false
    end
    add_index :schooltypes, :name, unique: true
  end
end
