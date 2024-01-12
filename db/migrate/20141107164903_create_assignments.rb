class CreateAssignments < ActiveRecord::Migration[4.2]
  def change
    create_table :assignments do |t|
      t.integer :program_id
      t.integer :supervisor_id
      t.date :start_date
      t.boolean :main, default: false
      t.timestamps
    end
  end
end
