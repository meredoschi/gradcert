class CreateAccreditations < ActiveRecord::Migration
  def change
    create_table :accreditations do |t|
      t.integer :institution_id
      t.date :initial
      t.date :renewed
      t.boolean :current
      t.boolean :revoked
      t.date :revocation
      t.string :comment, limit: 200
      t.timestamps
    end
    add_index :accreditations, :institution_id, unique: true
  end
end
