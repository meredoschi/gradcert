class CreateRegistrationkinds < ActiveRecord::Migration[4.2]
  def change
    create_table :registrationkinds do |t|
      t.boolean :regular, default: true
      t.boolean :makeup, default: false
      t.boolean :repeat, default: false
      t.boolean :veteran, default: false
      t.integer :previousregistrationid
      t.timestamps null: false
    end
  end
end
