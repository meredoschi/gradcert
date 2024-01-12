class FixColumnsSupervisor < ActiveRecord::Migration[4.2]
  def change
    change_table :supervisors do |t|
      t.remove :lead
      t.remove :alternate
      t.remove :program_start
      t.remove :program_id
      t.rename :work_start, :career_start
    end
  end
end
