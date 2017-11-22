# Sample model
class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :name, limit: 70

      t.timestamps null: false
    end
  end
end
