class CreateCompletions < ActiveRecord::Migration
  def change
    create_table :completions do |t|
      t.integer :registration_id
      t.boolean :inprogress
      t.boolean :fulfilled
      t.boolean :incomplete
      t.boolean :willmakeup
      t.boolean :madeup
      t.boolean :dnf

      t.timestamps null: false
    end
    add_index :completions, :registration_id, unique: true
  end
end
