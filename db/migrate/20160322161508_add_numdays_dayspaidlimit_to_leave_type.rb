class AddNumdaysDayspaidlimitToLeaveType < ActiveRecord::Migration
  def change
    add_column :leavetypes, :days, :integer
    add_column :leavetypes, :dayswithpaylimit, :integer
  end
end
