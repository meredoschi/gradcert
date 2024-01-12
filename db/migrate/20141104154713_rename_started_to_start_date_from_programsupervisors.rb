class RenameStartedToStartDateFromProgramsupervisors < ActiveRecord::Migration[4.2]
  def change
    change_table :programsupervisors do |t|
      t.rename :started, :start_date
    end
  end
end
