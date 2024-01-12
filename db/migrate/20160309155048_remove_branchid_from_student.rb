class RemoveBranchidFromStudent < ActiveRecord::Migration[4.2]
  def change
    change_table :students do |t|
      t.remove :bankbranch_id
    end
  end
end
