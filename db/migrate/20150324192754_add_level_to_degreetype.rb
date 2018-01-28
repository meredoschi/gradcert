class AddLevelToDegreetype < ActiveRecord::Migration
  def change
    add_column :degreetypes, :level, :integer
  end
end
