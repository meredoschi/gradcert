class AddManagersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :papmgr, :boolean, default: false
    add_column :users, :medresmgr, :boolean, default: false
    remove_column :users, :name
  end
end
