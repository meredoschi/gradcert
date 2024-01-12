class RemoveCouncilMembershipFromStudent < ActiveRecord::Migration[4.2]
  def change
    change_table :students do |t|
      t.remove :councilmembership
      t.remove :council_id
    end
  end
end
