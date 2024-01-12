class AddDaystartedDayfinishedToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :daystarted, :integer, default: 0
    add_column :events, :dayfinished, :integer, default: 0
  end
end
