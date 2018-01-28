class FixSupervisor < ActiveRecord::Migration
  def change
    change_table :supervisors do |t|
      t.remove :total_working_hours_week
      t.remove :teaching_hours_week
    end
  end
end
