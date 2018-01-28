class RemoveCouncilMembershipFromStudent < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.remove :councilmembership
      t.remove :council_id
    end
  end
end
