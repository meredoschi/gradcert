class AddPermissionToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :permission_id, :integer
  end
end
