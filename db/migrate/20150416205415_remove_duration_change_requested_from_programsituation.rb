class RemoveDurationChangeRequestedFromProgramsituation < ActiveRecord::Migration
  def change
    change_table :programsituations do |t|
      t.remove :duration_change_requested
    end
  end
end
