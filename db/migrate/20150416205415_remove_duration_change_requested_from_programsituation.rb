class RemoveDurationChangeRequestedFromProgramsituation < ActiveRecord::Migration[4.2]
  def change
    change_table :programsituations do |t|
      t.remove :duration_change_requested
    end
  end
end
