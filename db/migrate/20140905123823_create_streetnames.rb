class CreateStreetnames < ActiveRecord::Migration
  def change
    create_table :streetnames do |t|
      t.string :nome, limit: 50, null: false
      t.timestamps
    end
    add_index :streetnames, :nome, unique: true
  end
end
