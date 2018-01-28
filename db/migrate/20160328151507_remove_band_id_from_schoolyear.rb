class RemoveBandIdFromSchoolyear < ActiveRecord::Migration
  def change
    change_table :schoolyears do |t|
      t.remove :band_id
    end
  end
end
