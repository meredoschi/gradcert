class RemoveBandIdFromSchoolyear < ActiveRecord::Migration[4.2]
  def change
    change_table :schoolyears do |t|
      t.remove :band_id
    end
  end
end
