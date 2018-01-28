class AddCollaboratorsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :papcollaborator, :boolean, default: false
    add_column :users, :medrescollaborator, :boolean, default: false
  end
end
