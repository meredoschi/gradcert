class CreateRosters < ActiveRecord::Migration[4.2]
  def change
    create_table :rosters do |t|
      t.integer :institution_id, null: false
      t.integer :schoolterm_id, null: false
      t.integer :authorizedsupervisors, default: 0
      t.datetime :dataentrystart, null: false
      t.datetime :dataentryfinish, null: false
      t.timestamps null: false
    end
  end
end
