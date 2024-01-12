class AddPreviousnameToCoursename < ActiveRecord::Migration[4.2]
  def change
    add_column :coursenames, :previousname, :string, limit: 100
  end
end
