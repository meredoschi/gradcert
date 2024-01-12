class AddLevelToDegreetype < ActiveRecord::Migration[4.2]
  def change
    add_column :degreetypes, :level, :integer
  end
end
