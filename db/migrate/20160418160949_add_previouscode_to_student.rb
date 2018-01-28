class AddPreviouscodeToStudent < ActiveRecord::Migration
  def change
    add_column :students, :previouscode, :integer, limit: 8
  end
end
