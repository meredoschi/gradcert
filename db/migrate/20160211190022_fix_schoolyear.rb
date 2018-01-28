class FixSchoolyear < ActiveRecord::Migration
  def change
    change_table :schoolyears do |t|
      t.remove :convokedtoregister
      t.remove :candidates
      t.rename :approved, :pass
    end
  end
end
