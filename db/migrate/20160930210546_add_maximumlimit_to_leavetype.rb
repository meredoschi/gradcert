class AddMaximumlimitToLeavetype < ActiveRecord::Migration
  def change
    add_column :leavetypes, :maximumlimit, :integer, default: 731
  end
end
