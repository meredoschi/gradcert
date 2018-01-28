class ChangeDateFormatInMySupervisor < ActiveRecord::Migration
  def change
    change_column :supervisors, :career_start_date, :date
    change_column :supervisors, :graduation_date, :date
  end
end
