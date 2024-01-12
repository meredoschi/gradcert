class AddItStaffToRole < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :itstaff, :boolean, default: false
  end
end
