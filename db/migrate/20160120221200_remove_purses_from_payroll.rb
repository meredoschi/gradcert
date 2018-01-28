class RemovePursesFromPayroll < ActiveRecord::Migration
  def change
    change_table :payrolls do |t|
      t.remove :purse
      t.remove :purse_cents
    end
  end
end
