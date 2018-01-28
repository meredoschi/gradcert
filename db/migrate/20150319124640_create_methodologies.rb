class CreateMethodologies < ActiveRecord::Migration
  def change
    create_table :methodologies do |t|
      t.string :name, limit: 120
      t.timestamps
    end
    add_index :methodologies, :name, unique: true
  end
end
