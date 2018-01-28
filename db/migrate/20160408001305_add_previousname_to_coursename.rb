class AddPreviousnameToCoursename < ActiveRecord::Migration
  def change
    add_column :coursenames, :previousname, :string, limit: 100
  end
end
