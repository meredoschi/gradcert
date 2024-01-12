class RemoveEnrollmentFromSchoolyear < ActiveRecord::Migration[4.2]
  def change
    change_table :schoolyears do |t|
      t.remove :enrollment
    end
  end
end
