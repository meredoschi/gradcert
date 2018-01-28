class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :main, limit: 30
      t.string :mobile, limit: 30
      t.string :other, limit: 30
      t.integer :contact_id
      t.integer :institution_id
      t.timestamps
    end
  end
end
