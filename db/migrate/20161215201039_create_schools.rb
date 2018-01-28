class CreateSchools < ActiveRecord::Migration
  def change
    drop_table :schools if table_exists?(:schools)

    create_table :schools do |t|
      t.string :name, limit: 120
      t.string :abbreviation, limit: 25
      t.integer :ministrycode
      t.integer :academiccategory_id
      t.boolean :public, default: false

      t.timestamps null: false
    end
  end
end
