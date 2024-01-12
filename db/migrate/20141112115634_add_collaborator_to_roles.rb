class AddCollaboratorToRoles < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :collaborator, :boolean, default: false
  end
end
