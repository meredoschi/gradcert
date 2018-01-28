class CreateRegistrations < ActiveRecord::Migration
  def change
    drop_table :registrations if table_exists?(:registrations)

    create_table :registrations do |t|
      t.integer :student_id
      t.integer :schoolyear_id

      t.timestamps null: false
    end
  end
end
