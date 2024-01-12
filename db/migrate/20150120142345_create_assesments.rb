class CreateAssesments < ActiveRecord::Migration[4.2]
  def change
    drop_table :assesments if table_exists?(:assesments)

    create_table :assesments do |t|
      t.integer :contact_id
      t.integer :program_id
      t.boolean :duration_change_requested
      t.integer :expected_duration
      t.integer :expected_first_year_grants
      t.integer :expected_second_year_grants
      t.string :summary_of_program_goals, limit: 3000
      t.string :program_nature_vocation, limit: 3000
      t.integer :first_year_theory_hours
      t.integer :first_year_practice_hours
      t.integer :second_year_theory_hours
      t.integer :second_year_practice_hours
      t.integer :profession_id
      t.timestamps
    end

    add_index :assesments, %i[program_id contact_id]
  end
end
