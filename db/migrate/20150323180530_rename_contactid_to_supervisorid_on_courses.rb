class RenameContactidToSupervisoridOnCourses < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.rename :contact_id, :supervisor_id
    end
  end
end
