class RenameBrstateidToStateidOnStateregion < ActiveRecord::Migration
  def change
    change_table :stateregions do |t|
      t.rename :brstate_id, :state_id
    end
  end
end
