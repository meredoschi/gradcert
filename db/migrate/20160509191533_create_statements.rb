class CreateStatements < ActiveRecord::Migration[4.2]
  def change
    create_table :statements do |t|
      t.integer :registration_id
      t.integer :payroll_id
      t.integer :grossamount_cents
      t.integer :incometax_cents
      t.integer :socialsecurity_cents
      t.integer :childsupport_cents
      t.integer :netamount_cents

      t.timestamps null: false
    end
  end
end
