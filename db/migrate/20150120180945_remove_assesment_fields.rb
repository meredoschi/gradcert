class RemoveAssesmentFields < ActiveRecord::Migration
  def change
    change_table :assesments do |t|
      # duration
      t.remove :duration_change_requested
      t.remove :expected_duration
      # scholarships
      t.remove :expected_first_year_grants
      t.remove :expected_second_year_grants
      # program info
      t.remove :summary_of_program_goals
      t.remove :program_nature_vocation
      # hours
      t.remove :first_year_theory_hours
      t.remove :second_year_theory_hours
      t.remove :first_year_practice_hours
      t.remove :second_year_practice_hours
    end
  end
end
