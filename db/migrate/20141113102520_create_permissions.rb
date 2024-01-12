class CreatePermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :permissions do |t|
      t.string :kind, limit: 50, null: false
      t.string :description, limit: 150
      t.timestamps
    end
  end
end
