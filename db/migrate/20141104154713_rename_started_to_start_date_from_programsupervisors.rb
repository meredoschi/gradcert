class RenameStartedToStartDateFromProgramsupervisors < ActiveRecord::Migration
  def change
    change_table :programsupervisors do |t|
      t.rename :started, :start_date
    end
  end
end
