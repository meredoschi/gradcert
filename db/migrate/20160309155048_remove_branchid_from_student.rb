class RemoveBranchidFromStudent < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.remove :bankbranch_id
    end
  end
end
