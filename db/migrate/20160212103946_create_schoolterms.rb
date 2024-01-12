class CreateSchoolterms < ActiveRecord::Migration[4.2]
  def change
    create_table :schoolterms do |t|
      t.date :start, null: false
      t.date :finish, null: false
      t.boolean :active, default: true
      t.boolean :pap, default: false
      t.boolean :medres, default: false
      t.timestamps null: false
    end
  end
end
