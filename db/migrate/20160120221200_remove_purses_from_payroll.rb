class RemovePursesFromPayroll < ActiveRecord::Migration[4.2]
  def change
    change_table :payrolls do |t|
      t.remove :purse
      t.remove :purse_cents
    end
  end
end
