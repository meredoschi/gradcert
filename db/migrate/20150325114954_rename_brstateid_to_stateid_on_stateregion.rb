class RenameBrstateidToStateidOnStateregion < ActiveRecord::Migration[4.2]
  def change
    change_table :stateregions do |t|
      t.rename :brstate_id, :state_id
    end
  end
end
