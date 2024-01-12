class AddPapMedresToRoles < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :pap, :boolean
    add_column :roles, :medres, :boolean
  end
end
