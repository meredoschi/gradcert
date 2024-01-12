class CreateProgramsituations < ActiveRecord::Migration[4.2]
  def change
    create_table :programsituations do |t|
      t.integer :assesment_id
      t.boolean :duration_change_requested
      t.integer :expected_duration
      t.integer :expected_first_year_grants
      t.integer :expected_second_year_grants
      t.string  :summary_of_program_goals, limit: 3000
      t.string  :program_nature, limit: 3000
      t.integer :first_year_instructional_hours_theory
      t.integer :first_year_instructional_hours_practice
      t.integer :second_year_instructional_hours_theory
      t.integer :second_year_instructional_hours_practice
      t.timestamps
    end
    add_index :programsituations, :assesment_id, unique: true
  end
end
