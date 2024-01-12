class FixSchoolyear < ActiveRecord::Migration[4.2]
  def change
    change_table :schoolyears do |t|
      t.remove :convokedtoregister
      t.remove :candidates
      t.rename :approved, :pass
    end
  end
end
