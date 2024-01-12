class ChangeDateFormatInMySupervisor < ActiveRecord::Migration[4.2]
  def change
    change_column :supervisors, :career_start_date, :date
    change_column :supervisors, :graduation_date, :date
  end
end
