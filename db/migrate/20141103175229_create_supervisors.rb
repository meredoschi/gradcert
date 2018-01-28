class CreateSupervisors < ActiveRecord::Migration
  def change
    create_table :supervisors do |t|
      t.integer :contact_id
      t.datetime :work_start
      t.datetime :program_start
      t.integer :institution_id
      t.integer :profession_id
      t.string :highest_degree_held
      t.datetime :graduation_date
      t.boolean :lead, default: false
      t.boolean :alternate, default: false
      t.integer :total_working_hours_week
      t.integer :teaching_hours_week
      t.string :contract_type
      t.timestamps
    end
    add_index :supervisors, :contact_id, unique: true
  end
end
