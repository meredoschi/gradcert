class AddMaximumlimitToLeavetype < ActiveRecord::Migration[4.2]
  def change
    add_column :leavetypes, :maximumlimit, :integer, default: 731
  end
end
