class RemoveGrantsColumnsFromProgramSituation < ActiveRecord::Migration
  def change
    change_table :programsituations do |t|
      t.remove :recommended_first_year_grants
      t.remove :recommended_second_year_grants
    end
  end
end
