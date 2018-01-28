class RenameCareerFromSupervisors < ActiveRecord::Migration
  def change
    change_table :supervisors do |t|
      t.rename :career_start, :career_start_date
    end
  end
end
