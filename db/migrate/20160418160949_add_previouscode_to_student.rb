class AddPreviouscodeToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :previouscode, :integer, limit: 8
  end
end
