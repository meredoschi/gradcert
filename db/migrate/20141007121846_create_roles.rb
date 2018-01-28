class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, limit: 120, null: false
      t.boolean :management, default: false
      t.boolean :teaching, default: false
      t.boolean :clerical, default: false
      t.timestamps
    end
    add_index :roles, :name, unique: true
  end
end
