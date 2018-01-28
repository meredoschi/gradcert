class AddItStaffToRole < ActiveRecord::Migration
  def change
    add_column :roles, :itstaff, :boolean, default: false
  end
end
