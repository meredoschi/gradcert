class CreateTaxations < ActiveRecord::Migration
  def change
    create_table :taxations do |t|
      t.integer :socialsecurity
      t.integer :bracket_id

      t.timestamps null: false
    end
  end
end
