class RemoveEnrollmentFromSchoolyear < ActiveRecord::Migration
  def change
    change_table :schoolyears do |t|
      t.remove :enrollment
    end
  end
end
