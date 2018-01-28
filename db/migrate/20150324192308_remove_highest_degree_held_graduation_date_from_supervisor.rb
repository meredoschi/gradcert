class RemoveHighestDegreeHeldGraduationDateFromSupervisor < ActiveRecord::Migration
  def change
    change_table :supervisors do |t|
      t.remove :highest_degree_held
      t.remove :graduation_date
    end
  end
end
