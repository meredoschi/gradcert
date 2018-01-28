class AddPapMedresToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :pap, :boolean
    add_column :roles, :medres, :boolean
  end
end
