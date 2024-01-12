class RenameGrantsProgramSituation < ActiveRecord::Migration[4.2]
  def change
    change_table :programsituations do |t|
      t.rename :expected_first_year_grants, :recommended_first_year_grants
      t.rename :expected_second_year_grants, :recommended_second_year_grants
      t.rename :expected_duration, :recommended_duration
    end
  end
end
