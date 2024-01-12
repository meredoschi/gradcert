class AddCollaboratorsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :papcollaborator, :boolean, default: false
    add_column :users, :medrescollaborator, :boolean, default: false
  end
end
