class AddCollaboratorToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :collaborator, :boolean, default: false
  end
end
