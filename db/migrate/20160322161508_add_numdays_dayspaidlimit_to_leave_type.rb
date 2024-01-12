class AddNumdaysDayspaidlimitToLeaveType < ActiveRecord::Migration[4.2]
  def change
    add_column :leavetypes, :days, :integer
    add_column :leavetypes, :dayswithpaylimit, :integer
  end
end
