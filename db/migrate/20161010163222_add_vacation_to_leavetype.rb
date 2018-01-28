class AddVacationToLeavetype < ActiveRecord::Migration
  def change
    add_column :leavetypes, :vacation, :boolean, default: false
  end
end
