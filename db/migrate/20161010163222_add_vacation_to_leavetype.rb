class AddVacationToLeavetype < ActiveRecord::Migration[4.2]
  def change
    add_column :leavetypes, :vacation, :boolean, default: false
  end
end
