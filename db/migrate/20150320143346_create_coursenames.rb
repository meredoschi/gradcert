class CreateCoursenames < ActiveRecord::Migration
  def change
    create_table :coursenames do |t|
      t.string :name, limit: 200
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :coursenames, :name, unique: true
  end
end
