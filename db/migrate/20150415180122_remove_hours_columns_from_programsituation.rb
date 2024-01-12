class RemoveHoursColumnsFromProgramsituation < ActiveRecord::Migration[4.2]
  def change
    change_table :programsituations do |t|
      t.remove :first_year_instructional_hours_theory
      t.remove :first_year_instructional_hours_practice
      t.remove :second_year_instructional_hours_theory
      t.remove :second_year_instructional_hours_practice
    end
  end
end
