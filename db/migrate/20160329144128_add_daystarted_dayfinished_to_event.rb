class AddDaystartedDayfinishedToEvent < ActiveRecord::Migration
  def change
    add_column :events, :daystarted, :integer, default: 0
    add_column :events, :dayfinished, :integer, default: 0
  end
end
