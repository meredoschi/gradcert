class CreateSchoolnames < ActiveRecord::Migration[4.2]
  def change
    create_table :schoolnames do |t|
      t.string :name, limit: 200
      t.string :previousname, limit: 200
      t.boolean :active, default: true
      t.timestamps null: false
    end
  end
end
