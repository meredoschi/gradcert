class CreateLeavetypes < ActiveRecord::Migration
  def change
    create_table :leavetypes do |t|
      t.string :name, limit: 100
      t.boolean :paid, default: false
      t.string :comment, limit: 200
      t.timestamps null: false
    end

    add_index :leavetypes, :name, unique: true
  end
end
