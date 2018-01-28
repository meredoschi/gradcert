class ProgramSupervisors < ActiveRecord::Migration
  def change
    create_table :programsupervisors do |t|
      t.integer :supervisor_id
      t.integer :program_id
      t.date :started
      t.boolean :lead, default: false
      t.timestamps
    end
  end
end
