class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :pap, :boolean, default: false
    add_column :users, :paprh, :boolean, default: false
    add_column :users, :resmed, :boolean, default: false
    add_column :users, :resmedrh, :boolean, default: false
    add_column :users, :adminreadonly, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end
end
